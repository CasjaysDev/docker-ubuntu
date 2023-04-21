## 👋 Welcome to ubuntu 🚀  

Custom image with bash and tini installed  
  
  
## Run container

```shell
docker run --name -casjaysdev-ubuntu casjaysdev/ubuntu bash
```
  
  
## Install my system scripts  

```shell
 sudo bash -c "$(curl -q -LSsf "https://github.com/systemmgr/installer/raw/main/install.sh")"
 sudo systemmgr --config && sudo systemmgr install scripts  
```

## Get source files  

```shell
dockermgr download src casjaysdev/docker-ubuntu
```

OR

```shell
git clone "https://github.com/casjaysdev/docker-ubuntu" "$HOME/Projects/github/casjaysdev/docker-ubuntu"
```

## Build container  

```shell
cd "$HOME/Projects/github/casjaysdev/docker-ubuntu"
buildx 
```

## Authors  

🤖 casjay: [Github](https://github.com/casjay) 🤖  
⛵ casjaysdev: [Github](https://github.com/casjaysdev) [Docker](https://hub.docker.com/r/casjaysdev) ⛵  
