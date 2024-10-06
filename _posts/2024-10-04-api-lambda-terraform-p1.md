---
ayout: post
title: API Serverless com AWS, Golang e Terraform - Parte 1
description: Aprenda como construir uma API Serverless usando AWS Lambda e API Gateway com Golang, provisionando a infraestrutura com Terraform. Parte 1 de uma série prática.
categories: [Tutorial, AWS, Serverless]
tags: [AWS, Golang, Lambda, Terraform, API Gateway, Serverless]

---

# API Serverless com AWS, Golang e Terraform - Parte 1

## **Objetivo**
Criar uma **API serverless** usando `Terraform`, `API Gateway` e `Golang`, que pode rodar em qualquer nuvem. Vamos usar a AWS, mas o foco é deixar tudo pronto para funcionar em qualquer lugar.

## **O que é Serverless?**
Serverless é tipo pedir delivery: você cuida só do pedido (código), e o resto (servidores e manutenção) é com o restaurante (provedor). Vantagens:

- **Escalabilidade**: mais acessos? Ele se ajusta sozinho.
- **Agilidade**: desenvolve, testa e pronto.
- **Custo**: paga só pelo que usa.

### **Parte 1: Preparando o Ambiente**

### 1. **Criando sua Conta AWS**

1. Acesse [aws.amazon.com](https://aws.amazon.com) e clique em **Create an AWS Account**.
2. Siga o passo a passo para preencher os dados e verificar a conta.
3. Pegue suas **chaves de acesso**: no canto superior direito, clique no seu nome, vá em **My Security Credentials**, e crie uma nova **Access Key**.

### 3. **Instalando e Configurando o AWS CLI**

>Eu  vou usar **Ubuntu no WSL**. Mais vai de preferência.
{: .prompt-info }

- **Instalar AWS CLI**:

```bash
sudo apt update
sudo apt install awscli -y
```

- **Verificar instalação**:

```bash
aws --version
```

- **Configurar AWS CLI**:

```bash
aws configure
```

Insira suas credenciais, região padrão (`us-east-1`, por exemplo) e formato de saída (`json`). Teste listando seus buckets:

```bash
aws s3 ls
```

### 4. **Instalando o Terraform**

- **Baixar e Instalar**:

```bash
wget https://releases.hashicorp.com/terraform/1.5.4/terraform_1.5.4_linux_amd64.zip
unzip terraform_1.5.4_linux_amd64.zip
sudo mv terraform /usr/local/bin/
```

- **Verificar instalação**:

```bash
terraform -version
```

Agora você tem tudo pronto: **AWS** configurada e **Terraform** rodando no seu ambiente!


Claro! Aqui está uma versão mais simples e leve:

---

## **Criando a Estrutura do Projeto**
   
Vamos organizar o projeto de forma simples para que tudo fique fácil de achar e mexer. Aqui está a estrutura básica:
```bash
📦 tf-lambda-api
 ┣ 📂 terraform/
 ┃ ┣ 📜 main.tf       # Configurações do Terraform (API Gateway, Lambda, etc.)
 ┃ ┗ 📜 terraform.tfvars # Variáveis importantes (como chaves de acesso)
 ┣ 📜 main.go         # Código principal da API em Golang
 ┣ 📜 Makefile        # Automação de tarefas (compilar, rodar API, etc.)
 ┗ 📜 README.md       # Instruções de uso e detalhes do projeto

```
Com essa estrutura, o projeto fica organizado e pronto pra rodar sem complicação!

## **Escrevendo o Código da Função Lambda**

Agora vamos colocar a mão na massa e criar o código da nossa função Lambda em **Golang**! Essa função vai ser a responsável por responder às solicitações que chegam pela nossa API. Vamos fazer algo simples, mas muito legal!


**Crie a Função Lambda**:
   Abra o arquivo **`main.go`** e vamos definir a nossa função Lambda. Olha só como é fácil:

   ```go
  package main

    import (
        "fmt"
        "net/http"
    )

    func handler(w http.ResponseWriter, r *http.Request) {
        fmt.Fprintf(w, "Hello, é eu!")
    }

    func main() {
        http.HandleFunc("/", handler)
        fmt.Println("Starting server on port 8080...")
        http.ListenAndServe(":8080", nil)
    }
 
   ```

**Testar Localmente**:
   Antes de enviar nossa estrela para o céu da AWS, que tal testá-la localmente? Use o `Makefile` para tornar isso mais fácil e rápido!

    ```bash
    # Nome do projeto
    PROJECT_NAME = tf-lambda-api

    # Diretório de build
    BUILD_DIR = bin
    LAMBDA_EXECUTABLE = $(BUILD_DIR)/lambda_function

    # Criar o diretório de build, se não existir
    .PHONY: all
    all: build

    # Compilar o código
    .PHONY: build
    build:
        mkdir -p $(BUILD_DIR)
        go build -o $(LAMBDA_EXECUTABLE) main.go

    # Testar localmente
    .PHONY: build
    test:
        go run main.go

    # Limpar os arquivos de build
    .PHONY: clean
    clean:
        rm -rf $(BUILD_DIR)

    # Ajuda
    .PHONY: help
    help:
        @echo "Comandos disponíveis:"
        @echo "  make build    - Compila o código da função Lambda"
        @echo "  make test     - Executa a função handler localmente"
        @echo "  make clean    - Limpa os arquivos de build"
        @echo "  make help     - Mostra essa mensagem"

    ```

## Vamos Subir o Código antes de continuar? 

Agora que a API está pronta, vamos subir o código pro GitHub de forma rápida com o **GitHub CLI**. 

>Se você ainda não conhece, dá uma olhada no [meu post anterior](http://www.blackwidow.com.br/posts/github-cli/) pra aprender mais.
{: .prompt-info }

### Criar o Repositório

Se ainda não criou o repositório, é só rodar:

```bash
gh repo create tf-lambda-api --public
```

Pronto, repositório criado no GitHub.

### Adicionar e Subir as Mudanças

Adicione o código e faça o commit:

```bash
git add .
git commit -m "commit inicial: adicionando o código da API"
gh repo sync
```

Isso garante que o repositório local e o do GitHub estejam sincronizados.

### Verificar o Repositório

Quer ver o repositório no navegador? Rode:

```bash
gh repo view --web
```

Simples e rápido! Agora seu código está no GitHub. Com tudo funcionando direitinho, é hora de brilhar! Vamos usar o Terraform para implantar a nossa função como uma Lambda na AWS e ver nossa criação em ação. 

---
