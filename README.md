## Code Education | Desenvolvimento de Aplicações Modernas e Escaláveis com Microsserviços

Code Education - Full Cycle Turma 7.  

As seguintes tecnologias são utilizadas neste projeto:  
* Nginx
* PHP-FPM
* Redis
* MySQL

---

## DevOps | Iniciando com Docker - Publicando imagem Laravel

Imagem Docker - Laravel: [https://hub.docker.com/r/kaissi/devops-docker-laravel](https://hub.docker.com/r/kaissi/devops-docker-laravel).  
Imagem Docker - Desafio Docker: [https://hub.docker.com/r/kaissi/codeeducation](https://hub.docker.com/r/kaissi/codeeducation).

## 1. Gerando arquivos Laravel

Na pasta [base](.scripts/base/) está o [Dockerfile](.scripts/base/Dockerfile) que é utilizado para gerar os arquivos Laravel.

**_Após os arquivos Laravel terem sido gerados, não será mais necessário executar este passo._**

Para gerar os arquivos, executar `make generate-laravel-files`

Executar `make build-base` para gerar a imagem base que será utilizada na aplicação.

## 2. Executando o sistema

### 2.1 Standalone

Na pasta raiz do projeto, onde agora estão os arquivos Laravel, também estão [docker-compose.yaml](docker-compose.yaml) e [docker-compose.override.yaml](docker-compose.override.yaml) que utilizaremos para executar o sistema.

```bash
docker-compose up --detach --build
```
No GCP, utilizaremos o arquivo [docker-compose.cloudbuild.yaml](docker-compose.cloudbuild.yaml) no lugar de [docker-compose.override.yaml](docker-compose.override.yaml):

```bash
docker-compose up --detach --build \
    -f docker-compose.yaml \
    -f docker-compose.cloudbuild.yaml
```

### 2.2 Kubernetes

Criar o password do MySQL:
```bash
kubectl create secret generic mysql-pass --from-literal=password='a1s2d3f4'
```

Subir o MySQL (será criado o Persistent Volume automaticamente):
```bash
kubectl apply -f .k8s/mysql/deployment.yaml
```

Subir o Redis:
```bash
kubectl apply -f .k8s/redis/deployment.yaml
```

Subir o Nginx:
```bash
kubectl apply -f .k8s/nginx/deployment.yaml
```

Por fim, subir a aplicação substituindo `img-app-deployment` pelo nome da imagem correta em [.k8s/app/deployment.yaml](.k8s/app/deployment.yaml)
```bash
kubectl apply -f .k8s/app/deployment.yaml
```

Abrir no browser o IP externo gerado pelo serviço `nginx-service`

\* No GCP todos estes passos devem ser feitos antes do cloudbuild executar, com exceção da substituição de `img-app-deployment` pelo nome da imagem gerada que é feita automaticamente, assim como o deploy no cluster do Kubernetes que também é feito automaticamente. Ver o arquivo [cloudbuild.prod.yaml](cloudbuild.prod.yaml)

## 3. Compilando Docker Multi-Plataforma (amd64, arm64, armv7, armhf)

Leia mais sobre [buildx][] para saber como funciona e como habilitá-lo no Docker.

O comando `make help` mostra as opções para compilar o projeto.

Para executar o build padrão, gerando apenas para a plataforma local, executar:  
`make build`

Internamente é executado:  
```bash
docker build \
    -t kaissi/devops-docker-laravel:latest-default \
    -f Dockerfile.prod.build \
    .
```

Para executar o buildx, gerando imagem Docker para múltiplas plataformas, fazer:  
`make build-all`

Caso dê algum erro para compilar uma plataforma diferente, executar o seguinte comando para a(s) plataforma(s) com erro:  
```bash
docker run --rm --privileged aptman/qus -s -- -p aarch64
```

Para remover o suporte a uma ou mais plataformas específicas, executar:  
```bash
docker run --rm --privileged aptman/qus -- -r aarch64
```

Para fazer o build para uma plataforma específica, fazer:  
`make build-armv7`

Internamente está sendo executado:  
```bash
docker buildx build \
    --pull \
    --load \
    -t kaissi/devops-docker-laravel:latest-armv7 \
    --platform linux/arm/v7 \
    -f Dockerfile.prod.build \
    .
```

Para que ao executar `docker pull kaissi/devops-docker-laravel:latest`, o Docker consiga escolher a plataforma automaticamente, executar `make release`. Este comando irá gerar o build para todas as plataformas (`make get-archs`), fazer o push para o Docker Hub de todas as imagens, e gerar e fazer o push do manifest para estas plataformas. 

[buildx]: <https://docs.docker.com/buildx/working-with-buildx/>

## 4. Gerando docker otimizado para produção

Na pasta raiz do projeto fazer:

```bash
docker build . -t kaissi/devops-docker-laravel-optimized:latest \
    -f Dockerfile.build \
    --build-arg APP_PORT=9000 \
    --build-arg DOCKERIZE_VERSION=v0.6.1
```

Note que o argumentos APP_PORT e DOCKERIZE_VERSION são opcionais. Se não passados, irão com os valores padrão definidos no Dockerfile.
