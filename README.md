# docker-environment
Deploy a docker environment with Portainer and Traefik easily !

## Deploy on Debian / Ubuntu
### Export variables
```bash
export EMAIL=<your_email>
export NDD=<your_domain>
export PASSWORD_TRAEFIK=<your_password>
```

### Use script
```bash
bash -c "$(curl -s https://raw.githubusercontent.com/PAPAMICA/docker-environment/main/install-docker-environment.sh)"
```

### Redirect URL to IP
You need to redirect this URL to server IP:
- traefik.ndd
- portainer.ndd

## Deploy on Infomaniak Public Cloud (or OpenStack)
You can use my heat template with this command:
