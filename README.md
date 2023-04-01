## 👋 Welcome to ubuntu 🚀  

ubuntu README  
Custom image with bash and tini installed  
  
## Run container

```shell
docker run casjaysdev/ubuntu bash
```
  
  
## Install my system scripts  

```shell
 sudo bash -c "$(curl -q -LSsf "https://github.com/systemmgr/installer/raw/main/install.sh")"
 sudo systemmgr --config && sudo systemmgr install scripts  
```

## Get source files  

```shell
dockermgr download src ubuntu
```

OR

```shell
git clone "https://github.com/casjaysdevdocker/ubuntu" "$HOME/Projects/github/casjaysdevdocker/ubuntu"
```

## Build container  

```shell
cd "$HOME/Projects/github/casjaysdevdocker/ubuntu"
buildx 
```

## Authors  

📽 dockermgr: [Github](https://github.com/dockermgr) [Docker](https://hub.docker.com/r/casjaysdevdocker) 📽  
🤖 casjay: [Github](https://github.com/casjay) [Docker](https://hub.docker.com/r/casjay) 🤖  
⛵ CasjaysDevDocker: [Github](https://github.com/casjaysdevdocker) [Docker](https://hub.docker.com/r/casjaysdevdocker) ⛵  
