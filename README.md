## Code Education | Desenvolvimento de Aplicações Modernas e Escaláveis com Microsserviços

Code Education - Full Cycle Turma 7.  

As seguintes tecnologias são utilizadas neste projeto:  
* Nginx
* PHP-FPM
* Redis
* MySQL

---

## DevOps | Iniciando com Docker - Publicando imagem Laravel

Image Docker: [https://hub.docker.com/r/kaissi/devops-docker-laravel](https://hub.docker.com/r/kaissi/devops-docker-laravel).

## 1. Gerando arquivos Laravel

Na pasta [start](start/) está o [Dockerfile](start/Dockerfile) que é utilizado para gerar os arquivos Laravel.

**_Após os arquivos Laravel terem sido gerados, não será mais necessário executar este passo._**

```bash
cd start

docker build . -t kaissi/devops-docker-laravel:latest

docker volume create \
    --driver local \
    --opt type=none \
    --opt device=$(pwd)/src \
    --opt o=bind \
    laravel-data

docker run \
    --detach \
    --name generate-laravel-files \
    -v laravel-data:/var/www \
    kaissi/devops-docker-laravel:latest

docker rm -f generate-laravel-files

docker volume rm laravel-data

mv ../{docker-compose.yaml,LICENSE,README.md} src \
    && for file in $(ls -A src); do mv src/${file} ../; done \
    && rm -rf src

cd ../
```

Fazer as seguintes alterações no arquivo [.env](.env):

> MYSQL_HEALTH_PORT_TARGET=8081  
> MYSQL_HEALTH_READINESS_FILE=readiness.sh  
> DB_HOST=db  
> DB_PASSWORD=root  
> REDIS_HOST=redis  
---

## 2. Executando o sistema

Na pasta raiz do projeto, onde agora estão os arquivos Laravael, também está o [docker-compose.yaml](docker-compose.yaml) que utilizaremos para executar o sistema.

```bash
docker-compose up --detach --build
```