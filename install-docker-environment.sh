#!/bin/bash -v
apt update && apt upgrade -y
apt install -y curl apt-transport-https ca-certificates gnupg2 software-properties-common apache2-utils
curl -fsSL https://download.docker.com/linux/$(. /etc/os-release; echo "$ID")/gpg | apt-key add -
add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/$(. /etc/os-release; echo "$ID") $(lsb_release -cs) stable"
apt-get update
apt-get -y install docker-ce docker-compose
systemctl enable docker
systemctl start docker
mkdir -p /apps/traefik/config
cat <<EOF >>/apps/traefik/config/traefik.yml
api:
  dashboard: true

log:
  level: INFO

entryPoints:
  http:
    address: ":80"
    http:
      redirections:
        entryPoint:
          to: https
          scheme: https
  https:
    address: ":443"
    http:
      tls:
        certResolver: http

providers:
  docker:
    endpoint: "unix:///var/run/docker.sock"
    exposedByDefault: false
  file:
    directory: custom/
    watch: true

certificatesResolvers:
  http:
    acme:
      email: $EMAIL
      storage: acme.json
      httpChallenge:
        entryPoint: http

serverstransport:
  insecureskipverify: true
EOF
cat <<EOF >>/apps/traefik/config/config.yml
http:
  middlewares:
    https-redirect:
      redirectScheme:
        scheme: https

    default-headers:
      headers:
        frameDeny: true
        sslRedirect: true
        browserXssFilter: true
        contentTypeNosniff: true
        forceSTSHeader: true
        stsIncludeSubdomains: true
        stsPreload: true

    secured:
      chain:
        middlewares:
        - default-headers

tls:
  options:
    default:
      minVersion: VersionTLS13
      sniStrict: true
EOF
touch /apps/traefik/config/acme.json
chmod 600 /apps/traefik/config/acme.json
docker network create proxy
USERPASS=$(echo $(htpasswd -nb admin $PASSWORD_TRAEFIK) | sed -e s/\\$/\\$\\$/g)
cat <<EOF >>/apps/traefik/docker-compose.yml
version: "3.3"
services:
    traefik:
        image: traefik:latest
        container_name: traefik
        restart: always
        healthcheck:
          test: grep -qr "traefik" /proc/*/status || exit 1
          interval: 1m
          timeout: 30s
          retries: 3
        ports:
            - 80:80
            - 443:443
        volumes:
            - /etc/localtime:/etc/localtime:ro
            - /var/run/docker.sock:/var/run/docker.sock:ro
            - /apps/traefik/config/traefik.yml:/traefik.yml:ro
            - /apps/traefik/config/config.yml:/config.yml:ro  
            - /apps/traefik/config/acme.json:/acme.json
            - /apps/traefik/config/custom:/custom:ro
        labels:
          # Front API
          autoupdate: monitor
          traefik.enable: true
          traefik.http.routers.api.entrypoints: https
          traefik.http.routers.api.rule: Host("traefik.$NDD")
          traefik.http.routers.api.service: api@internal
          traefik.http.routers.api.middlewares: auth
          traefik.http.routers.api.middlewares: traefik-forward-auth
          traefik.http.middlewares.auth.basicauth.users: admin:$USERPASS
        networks:
            - proxy

networks:
    proxy:
        external:
            name: proxy
EOF
docker-compose -f /apps/traefik/docker-compose.yml up -d
mkdir -p /apps/portainer
cat <<EOF >>/apps/portainer/docker-compose.yml
version: '2'
  
services:
  portainer:
    image: portainer/portainer-ce:latest
    container_name: portainer
    restart: unless-stopped
    security_opt:
      - no-new-privileges:true
    networks:
      - proxy
    environment:
      - TEMPLATES="https://raw.githubusercontent.com/PAPAMICA/docker-compose-collection/master/templates-portainer.json"
    volumes:
      - /etc/localtime:/etc/localtime:ro
      - /var/run/docker.sock:/var/run/docker.sock:ro
      - /apps/portainer/data:/data
    labels:
      - autoupdate=monitor
      - traefik.enable=true
      - traefik.http.routers.portainer.entrypoints=https
      - traefik.http.routers.portainer.rule=Host("portainer.$NDD")
      - traefik.http.routers.portainer.service=portainer
      - traefik.http.services.portainer.loadbalancer.server.port=9000
      - traefik.docker.network=proxy
networks:
  proxy:
    external: true
EOF
docker-compose -f /apps/portainer/docker-compose.yml up -d