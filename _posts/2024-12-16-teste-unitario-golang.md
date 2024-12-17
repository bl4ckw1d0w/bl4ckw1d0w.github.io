---

layout: post  
title: "Descomplicando Testes Unitários em Go: Um Guia Descontraído com Exemplo Real"  
description: "Vem ver como os testes unitários podem salvar seu código e sua sanidade, com exemplos práticos usando o projeto Dev Starter."  
categories: [Desenvolvimento, Golang]  
tags: [testes]  

---

Mais um! Vamos falar sobre testes unitários em Go? Eu sei que muita gente acha que testar código é **coisa de programador chato**, mas vou te mostrar que isso pode ser divertido e, mais importante, super útil! Vou usar o **Dev Starter**, que é meu projeto sensacional que estou desenvolvendo. Ele automatiza as configurações no WSL, como exemplo.

## O Que São Testes Unitários?

Testes unitários são tipo aqueles lembretes de "não se esqueça do guarda-chuva!" antes de sair de casa. Eles te avisam quando algo pode dar errado no seu código, antes que você mande ele rodar no mundo real.

Resumindo: um teste unitário garante que cada pedacinho do seu programa (uma função, método, etc.) funcione direitinho, sem causar problemas no resto.

## Como Funciona o Teste Unitário em Go?

No Go, é tudo simples e direto. Para criar um teste:

1. Nomeie o arquivo de teste com `_test.go` no final.
2. Crie uma função `func TestXxx(t *testing.T)` no pacote principal ou em um pacote separado de teste.
3. Dentro dessa função, use métodos do `testing.T` para validar os resultados.

## O Projeto de Exemplo: Dev Starter

### O Que É o Dev Starter?

O Dev Starter é meu projeto para ajudar desenvolvedores a configurar ambientes automaticamente no WSL. Ele instala editores, frameworks, e até o **Nix** para gerenciar pacotes. Muito prático, né?

Agora vamos colocar a mão na massa e escrever alguns testes para ele.

Claro! Vamos explicar o código parte por parte, detalhando o que cada parte faz. Aqui está o código de exemplo para o teste da função `SetupWSL`, com a explicação em cada etapa.

### 1. **Definição do Mock: `MockCommandExecutor`**

```go
type MockCommandExecutor struct {
	Calls []string // Armazena os comandos executados
	Err   error    // Simula um erro, se necessário
}
```

- **`MockCommandExecutor`** é uma struct que simula a execução de comandos. 
  - **`Calls`** é um slice que vai armazenar todos os comandos que foram "executados".
  - **`Err`** é uma variável para simular um erro, caso você precise testar como o código reage a falhas de execução de comandos.

### 2. **Implementação do Método `Execute` para o Mock**

```go
func (m *MockCommandExecutor) Execute(name string, arg ...string) error {
	// Registra o comando chamado
	command := name + " " + concatArgs(arg)
	m.Calls = append(m.Calls, command)
	return m.Err
}
```

  - O método **`Execute`** simula a execução de um comando. 
  - Ele recebe o nome do comando e seus argumentos (`name` e `arg`).
  - A função **`concatArgs`** é chamada para unir os argumentos em uma string única, e o comando resultante é adicionado à lista **`Calls`**.
  - O método retorna um erro (se for definido) para testar situações onde a execução falha.

### 3. **Função de Auxílio `concatArgs`**

```go
func concatArgs(args []string) string {
	result := ""
	for _, arg := range args {
		result += arg + " "
	}
	return result[:len(result)-1] // Remove o último espaço extra
}
```

- **`concatArgs`** é uma função auxiliar para transformar um slice de strings (`args`) em uma única string, onde os argumentos são separados por espaços.
- No final, o último espaço é removido para garantir que a string final seja formatada corretamente.

### 4. **Função de Teste: `TestSetupWSL`**

```go
func TestSetupWSL(t *testing.T) {
	mockExecutor := &MockCommandExecutor{}
```

- Aqui, criamos uma instância de **`MockCommandExecutor`** chamada `mockExecutor`, que usaremos para capturar os comandos que seriam executados.

### 5. **Chamada da Função `SetupWSL` com o Mock**

```go
	// Executa a função com o mock
	SetupWSL(mockExecutor)
```

- A função **`SetupWSL`** é chamada, passando o `mockExecutor` como parâmetro. Ao invés de executar comandos reais no sistema, a função agora usará o mock, o que garante que os comandos não sejam realmente executados.
  
### 6. **Verificação dos Comandos Esperados**

```go
	// Verifica se os comandos esperados foram chamados
	expectedCommands := []string{
		"powershell.exe -Command Start-Process PowerShell -Verb RunAs -ArgumentList 'Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Windows-Subsystem-Linux -All'",
		"powershell.exe -Command Start-Process PowerShell -Verb RunAs -ArgumentList 'wsl --install -d Debian'",
		"wsl -d Debian",
		"wsl --shutdown",
		"wsl -d Debian",
	}
```

- Aqui, criamos uma lista **`expectedCommands`** com os comandos que esperamos que a função **`SetupWSL`** tenha chamado.
- Esses são os comandos que o `mockExecutor` deverá capturar, caso a função tenha se comportado corretamente.

### 7. **Comparação dos Comandos Executados com os Esperados**

```go
	for i, expected := range expectedCommands {
		if i >= len(mockExecutor.Calls) {
			t.Fatalf("Esperava mais comandos: %s", expected)
		}

		if mockExecutor.Calls[i] != expected {
			t.Errorf("Comando #%d incorreto: esperado '%s', obteve '%s'", i+1, expected, mockExecutor.Calls[i])
		}
	}
```

- **Loop**: Para cada comando na lista `expectedCommands`, comparamos se o comando registrado no mock é o mesmo.
- Se o número de comandos executados for menor do que o esperado, o teste falha com uma mensagem dizendo que faltou um comando.
- Se algum comando não corresponder, o teste falha e indica qual comando foi esperado e qual foi executado de fato.

### 8. **Verificação do Número de Comandos Executados**

```go
	if len(mockExecutor.Calls) != len(expectedCommands) {
		t.Errorf("Número de comandos incorreto: esperado %d, obteve %d", len(expectedCommands), len(mockExecutor.Calls))
	}
```

- Aqui, verificamos se o número total de comandos executados corresponde ao número de comandos esperados.
- Se o número de comandos for diferente, o teste falha.
Claro! Vamos separar a parte 3 do processo, que é **"Rodando os Testes"**, em detalhes para você entender melhor o que fazer:

### 3. **Rodando os Testes**

Agora que você escreveu os testes, o próximo passo é rodá-los para verificar se tudo está funcionando corretamente. Para rodar seus testes em Go, você vai usar o comando `go test`.

#### Passos para Rodar os Testes:

1. **Abrir o Terminal**: Navegue até o diretório onde seu código de testes está localizado.

2. **Rodar o Comando para Testar**:

   Execute o seguinte comando no terminal:

   ```bash
   # use a pasta em que o arquivo de teste está: no meu caso ta em config
   go test -v ./config
   ```

   O `-v` é uma opção que significa "verbose", ou seja, vai mostrar um output mais detalhado dos testes que estão sendo executados.

#### O Que Acontece Quando Você Roda os Testes?

- **Se os testes passarem**, você verá algo assim no terminal:

   ```bash
   === RUN   TestSetupWSL
   --- PASS: TestSetupWSL (0.00s)
   PASS
   ok      seu_pacote/config  0.001s
   ```

>Isso indica que o teste foi bem-sucedido.
{: .prompt-info }

No meu ficou assim:

``` bash
$ go test -v ./config

=== RUN   TestSetupWSL
time="2024-12-16T10:21:23-03:00" level=info msg="WSL habilitado com sucesso! Preparando o ambiente Linux no Windows..."
time="2024-12-16T10:21:23-03:00" level=info msg="Debian instalado! Linux está a caminho..."
time="2024-12-16T10:21:23-03:00" level=info msg="Debian aberto para configuração inicial. Aproveite essa experiência Linux!"
time="2024-12-16T10:21:53-03:00" level=info msg="WSL encerrado. Vamos continuar a configuração!"
--- PASS: TestSetupWSL (30.00s)
PASS
ok      github.com/bl4ckw1d0w/dev-starter/config        (cached)

```

- **Se os testes falharem**, você verá algo assim no terminal:

   ```bash
   === RUN   TestSetupWSL
   --- FAIL: TestSetupWSL (0.00s)
       setup_wsl_test.go:XX: Os comandos executados não coincidem com os esperados
   FAIL
   exit status 1
   FAIL    seu_pacote/config  0.001s
   ```

> Neste caso, o teste falhou e você receberá uma mensagem de erro com detalhes sobre o que deu errado. O número **XX** representa a linha onde o erro ocorreu no arquivo de teste.
{: .prompt-danger }

#### **Rodar Testes com Cobertura**:

     Se quiser gerar um relatório de cobertura de testes, use:

     ```bash
     go test -cover
     ```
     
> Pode dar uma olhada na minha PR https://github.com/bl4ckw1d0w/dev-starter/pull/25 para dar uma olhada no codigo de teste e o de origem. 
 {: .prompt-info }


## Dicas Para Escrever Testes

1. **Mantenha os testes simples e focados.** Cada teste deve testar um único comportamento.
2. **Mocks são seus melhores amigos.** Não teste comandos reais que podem causar bagunça no seu ambiente.
3. **Use bibliotecas como `testify` para facilitar seus asserts.**


## Tendo dito...

Testar o código não precisa ser uma tarefa chata! Com as ferramentas certas e uma abordagem mais modular, você garante que seu código vai funcionar direitinho. E lembre-se: sempre rode seus testes antes de mandar aquele PR. 😉

Espero que tenha curtido esse guia rapidinho! Agora, que tal testar tudo no **Dev Starter**?