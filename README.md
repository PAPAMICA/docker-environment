<p align="center">
  <a href="https://papamica.com">
    <img src="https://zupimages.net/up/20/04/7vtd.png" width="140px" alt="PAPAMICA" />
  </a>
</p>

<p align="center">
  <a href="#"><img src="https://readme-typing-svg.herokuapp.com?center=true&vCenter=true&lines=Docker+environment;"></a>
</p>
<br />
    Deploy a docker environment with Portainer and Traefik easily !

<p align="center">
    <a href="https://github.com/PAPAMICA/docker-environment#deploy-on-debian--ubuntu"><img src="https://img.shields.io/badge/Deploy_on_Debian-%2341454A.svg?style=for-the-badge&logo=target&logoColor=white"> </a>
    <a href="https://github.com/PAPAMICA/docker-environment#deploy-on-infomaniak-public-cloud-or-openstack"><img src="https://img.shields.io/badge/Deploy_on_Infomaniak_Public_cloud_(openstack)-%2341454A.svg?style=for-the-badge&logo=target&logoColor=white"> </a>
    <br /><br />
    <a href="https://www.docker.com/"><img src="https://img.shields.io/badge/docker-%232496ED.svg?style=for-the-badge&logo=docker&logoColor=white"> </a>
    <a href="https://www.portainer.io/"><img src="https://img.shields.io/badge/portainer-%2313BEF9.svg?style=for-the-badge&logo=portainer&logoColor=white"> </a>
    <a href="https://traefik.io/traefik/"><img src="https://img.shields.io/badge/traefik_proxy-%231F93B1.svg?style=for-the-badge&logo=traefikmesh&logoColor=white"> </a>
    <a href="https://www.debian.org/index.fr.html"><img src="https://img.shields.io/badge/Debian-%23A81D33.svg?style=for-the-badge&logo=debian&logoColor=white"> </a>
    <a href="https://www.infomaniak.com/fr/hebergement/public-cloud"><img src="https://img.shields.io/badge/Openstack-%23ED1944.svg?style=for-the-badge&logo=openstack&logoColor=white"> </a>
    <br />
</p>

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

---

## Deploy on Infomaniak Public Cloud (or OpenStack)
You can use my heat template with this command:
```bash
openstack stack create --template https://raw.githubusercontent.com/PAPAMICA/docker-environment/main/Heat-template/docker-environment.yml docker --wait \
--parameter image='Debian 11.3 bullseye' \
--parameter flavor='a4-ram8-disk50-perf1' \
--parameter key='<YOUR_KEY>' \
--parameter EMAIL='<YOUR_EMAIL>' \
--parameter NDD='<YOUR_NDD>'
```

Check result and get IP:
```console
 openstack stack show docker

+-----------------------+----------------------------------------------------------------------------------------------------------------------------------+
| Field                 | Value                                                                                                                            |
+-----------------------+----------------------------------------------------------------------------------------------------------------------------------+
| id                    | f88dde5f-3729-4893-b06b-b6e57a9620af                                                                                             |
| stack_name            | docker                                                                                                                           |
| description           | Docker Environment                                                                                                               |
| creation_time         | 2021-11-11T13:50:53Z                                                                                                             |
| updated_time          | None                                                                                                                             |
| stack_status          | CREATE_COMPLETE                                                                                                                  |
| stack_status_reason   | Stack CREATE completed successfully                                                                                              |
| parameters            | EMAIL: xxxxxxxx@xxxxxxxxx.xxx                                                                                                    |
|                       | NDD: wiki-tech.fr                                                                                                                |
|                       | OS::project_id: 7368f02b559648d0a9ff15bff29b464f                                                                                 |
|                       | OS::stack_id: f88dde5f-3729-4893-b06b-b6e57a9620af                                                                               |
|                       | OS::stack_name: docker                                                                                                           |
|                       | flavor: a4-ram8-disk50-perf1                                                                                                     |
|                       | floating_network_id: ext-floating1                                                                                               |
|                       | image: Debian 11.3 bullseye                                                                                                      |
|                       | key: PAPAMICA-INFOKEY                                                                                                            |
|                       | network: docker-network                                                                                                          |
|                       | subnet_id: docker-subnet                                                                                                         |
|                       |                                                                                                                                  |
| outputs               | - description: IP                                                                                                                |
|                       |   output_key: server_IP                                                                                                          |
|                       |   output_value: /!\ Don't forget to redirect traefik.xxxxx.xxx and portainer.xxxxx.xxx                                           |
|                       |     to 195.15.XXX.XX!                                                                                                            |
|                       | - description: Portainer URL                                                                                                     |
|                       |   output_key: portainer_url                                                                                                      |
|                       |   output_value: https://portainer.xxxxx.xxx                                                                                      |
|                       | - description: Traefik URL                                                                                                       |
|                       |   output_key: traefik_url                                                                                                        |
|                       |   output_value: https://traefik.xxxxx.xxx (admin / xXXxxXXXxx1111XXX1)                                                           |
|                       |                                                                                                                                  |
| links                 | - href: https://api.pub1.infomaniak.cloud/v1/xxxxxxxxxxxxxxxxxxx/stacks/docker/f88dde5f-3729-4893-b06b-b6e57a9620af              |
|                       |   rel: self                                                                                                                      |
|                       |                                                                                                                                  |
| deletion_time         | None                                                                                                                             |
| notification_topics   | []                                                                                                                               |
| capabilities          | []                                                                                                                               |
| disable_rollback      | True                                                                                                                             |
| timeout_mins          | None                                                                                                                             |
| stack_owner           | PCU-U2CAZJ4                                                                                                                      |
| parent                | None                                                                                                                             |
| stack_user_project_id | 1fff4ec137f842e0b1c9e022c7fcafa4                                                                                                 |
| tags                  | []                                                                                                                               |
|                       |                                                                                                                                  |
+-----------------------+----------------------------------------------------------------------------------------------------------------------------------+
```
Don't forget to redirect traefik.xxxxx.xxx and portainer.xxxxx.xxx to 195.15.XXX.XX!   
In this example, Traefik is accessible from : https://traefik.xxxxx.xxx with admin / xXXxxXXXxx1111XXX1 and Portainer is accessible from : https://portainer.xxxxx.xxx

## Templates for Portainer
Feel free to use my templates and docker-compose for Portainer: 
https://github.com/PAPAMICA/docker-compose-collection 

