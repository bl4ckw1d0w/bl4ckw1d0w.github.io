---
layout: post
title: API usando Kibanana como LOGGING
description: Aprenda a integrar o Kibana em sua API Dockerizada para visualizar logs de maneira eficiente, permitindo que você monitore e analise o desempenho da sua aplicação com facilidade!
categories: [Tutorial, API]
tags: [kibana, elasticsearch, docker, golang, postgres]
---

# Logging de API com Kibana: Um Projeto Simples e Prático

E aí, galera! Hoje vou compartilhar com vocês meu projeto de logging de API que usei em uma aplicação Dockerizada. O foco aqui é integrar tudo com o Kibana para ter uma visão clara do que tá rolando na minha API. Vamos nessa!

> Sobre como criar a API, o Docker e o PostgreSQL nos próximos posts. Esse é só um guia de como usar o Kibana para o logging da sua API.
{: .prompt-warning }

## Por Que Usar Kibana?

>Kibana é massa, Kibana é 10! 

Kibana é uma ferramenta incrível que permite visualizar dados armazenados no Elasticsearch. **E PASMEM: É DE GRAÇA!** Com ela, você pode criar gráficos, tabelas e dashboards interativos. E o melhor: **se você tem dificuldade com interfaces, vai achar "facin, facin".**

## Como Funciona?

**Estrutura do Projeto**: O projeto é dividido em alguns serviços no Docker, incluindo a API, o banco de dados PostgreSQL, Elasticsearch e Kibana. Vamos ver como integrar tudo na nossa API (mais conhecido como *SHOW ME THE CODE*).

Primeiro, criamos o cliente Elasticsearch na `main.go`:

```go
// main.go

package main

import (
	"fmt"
	"log"
	"os"

	"github.com/elastic/go-elasticsearch/v7"
)

var es *elasticsearch.Client

func main() {
	// Inicializar o cliente Elasticsearch
	es, err := elasticsearch.NewClient(elasticsearch.Config{
		Addresses: []string{
			os.Getenv("ELASTICSEARCH_HOST"),
		},
		Username: os.Getenv("ELASTICSEARCH_USER"),
		Password: os.Getenv("ELASTICSEARCH_PASSWORD"),
	})
	if err != nil {
		log.Fatalf("Erro ao criar cliente Elasticsearch: %v", err)
	}

	log.Println("Cliente Elasticsearch criado com sucesso")

	// Aqui você pode adicionar qualquer funcionalidade adicional que precise
	// para a interação com o Elasticsearch, se necessário.
}
```

**Depois, capturamos os Logs**: Cada vez que uma ação é realizada na API, como a criação de um usuário, um log é gerado e enviado para o Elasticsearch. A função `createUserHandler` registra o log no Elasticsearch quando um usuário é criado.

```go
// main.go

func createUserHandler(w http.ResponseWriter, r *http.Request) {
	// Aqui se cria o usuário, valida os dados e insere no banco de dados.

	// Registrar o log no Elasticsearch
	logToElasticsearch(fmt.Sprintf("Usuário %s criado com sucesso", user.Username))

	w.WriteHeader(http.StatusCreated)
	w.Write([]byte("Usuário criado com sucesso"))
}
```

**Agora fazemos o código ler e mostrar em JSON**: A função `logToElasticsearch` registra uma mensagem no Elasticsearch, transformando-a em JSON e enviando para um índice específico (logs). Ela também lida com possíveis erros, garantindo que tudo seja registrado direitinho.

```go
// main.go

func logToElasticsearch(message string) {
	// Cria um documento com a mensagem e a hora atual
	doc := map[string]interface{}{
		"message": message,
	}

	// Converte o documento para JSON
	docJSON, err := json.Marshal(doc)
	if err != nil {
		log.Printf("Erro ao marshaller o documento: %v", err)
	}

	// Envia o documento JSON para o Elasticsearch
	req := bytes.NewReader(docJSON)
	res, err := es.Index("logs", req)
	if err != nil {
		log.Printf("Erro ao enviar log para Elasticsearch: %v", err)
	}
	defer res.Body.Close() // Garante que o corpo da resposta seja fechado 

	// Verifica se a resposta do Elasticsearch é um erro
	if res.IsError() {
		log.Printf("Erro ao indexar log: %s", res.String()) 
	}
}
```

Assim finalizamos o código da main, a estrutura que vai comandar todo esse processo. Agora vamos para o arquivo do Docker!

## Configuração do Docker Compose

Para configurar tudo isso, eu usei um `docker-compose.yml` para gerenciar os serviços. Aqui está uma visão geral do que inclui:

### Serviço de API

```yaml
version: '3.8'

services:
  api:
    build: .
    ports:
      - "8080:8080"
    environment:
      - POSTGRES_HOST=exemplo
      - POSTGRES_USER=exemplo
      - POSTGRES_PASSWORD=exemplo
      - POSTGRES_DB=exemplo
      - ELASTICSEARCH_HOST=http://elasticsearch:9200  # Variável para Elasticsearch
      - ELASTICSEARCH_USER=elastic  # Usuário padrão do Elasticsearch
      - ELASTICSEARCH_PASSWORD=pass  # Senha do Elasticsearch
    depends_on:
      - db
      - elasticsearch
```

### Serviço do Banco de Dados

```yaml
db:
  image: postgres:latest
  environment:
    POSTGRES_USER: postgres
    POSTGRES_PASSWORD: postgres
    POSTGRES_DB: bwapi
  volumes:
    - postgres_data:/var/lib/postgresql/data
```

### Configurações do Elasticsearch e Kibana

> Usuários e senhas hardcoded. Meramente ilustrativas. NÃO FAÇAM ISSO EM CASA!
{: .prompt-warning }


```yaml
elasticsearch:
  image: docker.elastic.co/elasticsearch/elasticsearch:8.5.0
  environment:
    - discovery.type=single-node
    - ELASTIC_PASSWORD=pass  # Senha do usuário 'elastic'
    - xpack.security.http.ssl.enabled=false  # Desabilita HTTPS
  ports:
    - "9200:9200"
    - "9300:9300"
  volumes:
    - es_data:/usr/share/elasticsearch/data

kibana:
  image: docker.elastic.co/kibana/kibana:8.5.0
  environment:
    ELASTICSEARCH_HOSTS: "http://elasticsearch:9200"
    ELASTICSEARCH_USERNAME: "kibana_user"      # Use 'elastic' como usuário padrão
    ELASTICSEARCH_PASSWORD: "kibana_pass"      # A mesma senha do Elasticsearch
  ports:
    - "5601:5601"  # Porta padrão do Kibana
  depends_on:
    - elasticsearch

volumes:
  postgres_data:
  es_data:
```

Pra dar um PLUS++, criei um Makefile pra que ele pudesse fazer a construção do binário do Golang, subir todos os containers do Docker e deixar os links prontos.

```makefile
up: build
	@echo "Iniciando o ambiente com docker-compose"
	docker-compose up --build -d
	@sleep 2 # Esperar um pouco para o container iniciar
	@echo "A API está rodando em: http://localhost:8080"
	@echo "O Kibana está rodando em: http://localhost:5601/"
```

O código completo tá disponível [aqui](https://github.com/bl4ckw1d0w/bwapi.git) se você tiver mais curiosidade.

## Interface do Elasticsearch

Como vimos, a URL http://localhost:5601/ deve estar pronta para login. Use as credenciais que você adicionou no Docker.

![alt text](/assets/img/posts/elastic-login.png)

Agora 'seja' SIMPLES: use a barra de pesquisa do Elastic e digite `data views`, e logo vai aparecer a informação pra você.

![alt text](/assets/img/posts/kibana-data-view.png)

Crie uma nova data view com base na sua API.

![alt text](/assets/img/posts/kibana-create-data-view.png)

Pode dar o nome que preferir. Estou usando `log*` como padrão, porque não estou usando mais nenhum log, exceto os da única API.

![alt text](/assets/img/posts/kibana-data-vew-new.png)

Vamos de novo para a barra de pesquisa e escreva `Discover`. Isso vai te levar direto para a página que você quer.

![alt text](/assets/img/posts/kibana-discover.png)

> AMIGX: Pra que haja logs, é preciso movimentação. Então preparei um comando simples com a ferramenta `curl` pra facilitar a criação de usuários:
{: .prompt-info }


```bash
curl -X POST http://localhost:8080/create-user \
-H "Content-Type: application/json" \
-d '{"username": "novo_usuario", "password": "senha_secreta"}'
```

Caso não queira usar a linha de comando, pode usar ferramentas como Postman, Insomnia, etc. Faz um `POST` nesse link: http://localhost:8080/create-user e adicione o corpo JSON:

```json
{
    "username": "novo_usuario", 
    "password": "senha_secreta"
}
```

Daí deve aparecer exatamente assim no seu Elastic:

![alt text](/assets/img/posts/elastic-log.png)

## Dificuldades

### Permissões do Usuário Kibana

Por várias vezes, o Kibana não estava pronto quando eu subia todos os containers. Isso foi por falta de permissões corretas. Se acontecer com você, aqui vão algumas dicas que podem ajudar, bem [aqui](https://github.com/bl4ckw1d0w/bwapi.git) na documentação.

## Conclusão

Esse projeto é uma maneira prática de aprender sobre logging e visualização de dados. Se você está começando ou só quer aprimorar suas habilidades, eu recomendo fortemente dar uma olhada. O repositório tá disponível [aqui](https://github.com/bl4ckw1d0w/bwapi.git) e vou ficar feliz em ouvir o que vocês acham!

--- 

Espero que goste das melhorias! Se precisar de mais alguma coisa, é só avisar.