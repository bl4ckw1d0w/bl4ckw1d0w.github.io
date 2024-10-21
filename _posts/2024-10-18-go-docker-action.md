---
layout: post
title: "CI/CD com GitHub Actions para Projetos em Go: Do Código ao Deploy"
description: "Aprenda a configurar pipelines de CI/CD para projetos em Go usando GitHub Actions, com integração de Docker, testes automatizados e deploy."
categories: [DevOps, Pipeline]
tags: [github actions, go, docker]
---

Você já cansou de ficar rodando comandos manualmente toda vez que quer testar ou fazer deploy de uma aplicação? Eu também! É por isso que vou te mostrar como configurar uma pipeline de CI/CD usando **GitHub Actions** para nossos projetos em **Go**. E o melhor: vamos integrar com **Docker**, rodar **testes automatizados** e, claro, fazer o deploy como chefes. 🍕🤖

Então, pega o café ☕ e vamos nessa!

## O que é GitHub Actions? 🤔

Imagina um robô trabalhador que roda seus testes, builds, e até faz o deploy enquanto você está jogando seu jogo favorito ou assistindo sua série preferida. Isso é o **GitHub Actions**! Ele te ajuda a automatizar quase tudo dentro do GitHub, criando pipelines de integração contínua (CI) e entrega contínua (CD).

### Possibilidades com GitHub Actions 🚀

Além de CI/CD para projetos em Go, o **GitHub Actions** oferece uma infinidade de possibilidades para automatizar seu fluxo de trabalho. Você pode configurar pipelines para diferentes linguagens de programação, **integrar com serviços de terceiros como Slack** para notificações, **executar scripts personalizados**, e até mesmo **gerenciar tarefas de infraestrutura com ferramentas como Terraform**. Com a flexibilidade dos workflows YAML, você pode criar automações complexas que atendem exatamente às suas necessidades, tornando seu desenvolvimento mais eficiente e confiável. Explore as ações disponíveis no marketplace e descubra como o GitHub Actions pode transformar a maneira como você desenvolve e entrega software.

## Vamos colocar a mão na massa! 👩‍💻👨‍💻

### Estrutura básica do nosso projeto
![alt text](/assets/img/posts/docker-actions-diagram.png)

Vou supor que você já tenha um projeto Go rodando com Docker. Se não tiver, fica tranquila(o), aqui tem um mini setup básico:

```go
package main

import (
	"fmt"
	"net/http"
)

func handler(w http.ResponseWriter, r *http.Request) {
	fmt.Fprintf(w, "Hello, CI/CD!")
}

func main() {
	http.HandleFunc("/", handler)
	http.ListenAndServe(":8080", nil)
}
```

E o Dockerfile pra deixar tudo prontinho:

```Dockerfile
FROM golang:1.19-alpine

WORKDIR /app

COPY . .

RUN go mod download
RUN go build -o myapp

CMD ["./myapp"]
```

### Configurando o GitHub Actions 📦

Agora é a hora de brincar com o **GitHub Actions**! Vamos criar uma pipeline de CI/CD para testar, buildar e fazer deploy do nosso app Go.

No repositório do GitHub, crie a pasta `.github/workflows` e adicione um arquivo `ci.yml` com o seguinte conteúdo:

```yaml
name: Go CI/CD Pipeline

on:
  push:
    branches:
      - main
  pull_request:
    branches:
      - main

jobs:
  build:
    runs-on: ubuntu-latest

    steps:
      - name: Check out the code
        uses: actions/checkout@v2

      - name: Set up Go
        uses: actions/setup-go@v3
        with:
          go-version: 1.19

      - name: Install dependencies
        run: go mod download

      - name: Run tests
        run: go test ./...

      - name: Build Docker image
        run: docker build -t myapp .

      - name: Push Docker image to Docker Hub
        env:
          DOCKER_USERNAME: ${{ secrets.DOCKER_USERNAME }}
          DOCKER_PASSWORD: ${{ secrets.DOCKER_PASSWORD }}
        run: |
          echo "${{ secrets.DOCKER_PASSWORD }}" | docker login -u "${{ secrets.DOCKER_USERNAME }}" --password-stdin
          docker tag myapp ${{ secrets.DOCKER_USERNAME }}/myapp:latest
          docker push ${{ secrets.DOCKER_USERNAME }}/myapp:latest
```

### Quebrando os passos 🧩

- **Check out the code**: Clona o repositório para o ambiente da action.
- **Set up Go**: Configura a versão do Go (nesse caso, 1.19).
- **Install dependencies**: Baixa as dependências do projeto com `go mod download`.
- **Run tests**: Roda os testes automatizados.
- **Build Docker image**: Constrói a imagem Docker do seu app Go.
- **Push Docker image**: Publica a imagem no Docker Hub.

### Deploy automático 🌍

Se você tiver um serviço de hospedagem como AWS, DigitalOcean ou qualquer outro que suporte Docker, você pode adicionar mais um passo para fazer o deploy automático assim que a imagem for publicada. Aqui, vou mostrar um exemplo simples usando o **AWS**:

```yaml
      - name: Log in to Amazon ECR
        uses: aws-actions/amazon-ecr-login@v1

      - name: Push Docker image to ECR
        run: |
          docker tag myapp:latest ${{ secrets.ECR_URI }}/myapp:latest
          docker push ${{ secrets.ECR_URI }}/myapp:latest

      - name: Deploy to AWS ECS
        env:
          AWS_REGION: us-east-1  # Substitua pela sua região
        run: |
          aws ecs update-service --cluster my-cluster --service my-service --force-new-deployment --region $AWS_REGION

```


### Não esqueça das variáveis de ambiente! 🔐

Todos os segredos como senhas e chaves SSH precisam estar guardados de forma segura no **GitHub Secrets**. Vá no repositório, clique em "Settings" > "Secrets" > "Actions", e adicione suas variáveis como `DOCKER_USERNAME`, `DOCKER_PASSWORD`, etc.

![alt text](/assets/img/posts/actions-docker-running.png)

### Conclusão 🎉

Agora que você tem seu pipeline de CI/CD configurado, pode ficar tranquilo(a) enquanto o GitHub Actions faz a mágica acontecer. Testes automatizados, build com Docker, e deploy tudo rolando automaticamente. Um verdadeiro sonho, né? 💭 Além disso, as possibilidades são infinitas: você pode integrar notificações, gerenciar infraestrutura e muito mais. Para ver o código completo deste tutorial, visite o [repositório no GitHub](https://github.com/bl4ckw1d0w/go-docker-actions).

![alt text](/assets/img/posts/docker-hub.png)

---
