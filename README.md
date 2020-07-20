## Code Education | Desenvolvimento de Aplicações Modernas e Escaláveis com Microsserviços

Full Cycle Turma 7

## DevOps | Iniciando com Docker - Publicando imagem Laravel

Clique [aqui](https://hub.docker.com/r/kaissi/devops-docker-laravel) para acessar a imagem docker.

## Gerando arquivos Laravel

Na pasta [start](start/) está o [Dockerfile](start/Dockerfile) que é utilizado para gerar os arquivos Laravel.

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
```

Alterar no arquivo [.env](.env):

> MYSQL_HEALTH_PORT_TARGET=8081<br>
> MYSQL_HEALTH_READINESS_FILE=readiness.sh<br>
> DB_HOST=db<br>
> DB_PASSWORD=root<br>
> REDIS_HOST=redis<br>

**Após os arquivos Laravel terem sido gerados, não será mais necessário executar este passo.**

## Subindo todos os sistemas
Na pasta raiz do projeto, onde agora estão os arquivos Laravael, está também o [docker-compose.yaml](docker-compose.yaml) que utilizaremos para subir todos os sistemas.

```bash
docker-compose up --detach --build
```