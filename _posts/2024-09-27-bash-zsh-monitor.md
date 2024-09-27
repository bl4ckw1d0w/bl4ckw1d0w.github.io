---
layout: post
title: "Monitorando Mudanças no Seu Bashrc/Zshrc: Um Amigo para Configurações de Shell"
categories: [DevOps, Scripts]
tags: [bash, zsh, personalização, linux, script, automação, pentest]
---

## Monitorando Mudanças no Seu Bashrc/Zshrc: Um Amigo para Configurações de Shell

 Imagine que você fez várias alterações `.bashrc` ou no `.zshrc` e, de repente, algo começa a dar errado. No meu caso `compinit:503: no such file or directory: /usr/share/zsh/vendor-completions/_docker`. Ô RAIVA! Até eu consegui entender que linha foi alterada pra que isso podesse acontecer, FOI CHÃO. Por isso, lendo um posto do **Tai Duong**, descobri que tem como fazer backup desses arquivos e também ver as alterações feitas.
 
  PRONTO! Agora era só fazer o meu proprio script pra que isso nunca mais aconteça. Hoje eu quero compartilhar um script que detecta e registra mudanças nos arquivos de configuração do `.bashrc` ou no `.zshrc`! Com esse script, você pode rapidamente identificar o que mudou e até reverter para a configuração anterior. Isso economiza um tempo precioso (**MEU DEUS COMO AJUDA**).


## Para que serve mesmo esses arquivos?

Esses arquivos são como o coração do nosso terminal. Eles guardam todas as configurações que fazem o seu ambiente de trabalho ser do jeitinho que você gosta. Mas, com tantas personalizações — alias, funções e variáveis de ambiente — fica fácil se perder nas mudanças. Às vezes, você quer adicionar um novo comando ou mudar uma configuração, mas acaba esquecendo o que tinha lá antes. 

### Exemplos de configurações para `.bashrc`
```sh
# .bashrc - Arquivo de configuração do shell Bash

# Definindo o prompt do shell
PS1='[\u@\h \W]\$ '  # Formato: [usuário@host diretório]$

# Habilitando cores no terminal
force_color_prompt=yes

# Alias: atalhos para comandos comuns
alias ll='ls -la'  # Lista arquivos com detalhes
alias gs='git status'  # Atalho para verificar o status do Git
alias rm='rm -i'  # Pergunta antes de remover arquivos

# Variáveis de ambiente
export EDITOR='vim'  # Define o editor padrão como vim
export PATH="$PATH:$HOME/bin"  # Adiciona o diretório bin do usuário ao PATH

# Funções personalizadas
function mkcd() {
    mkdir -p "$1" && cd "$1"  # Cria um diretório e entra nele
}

# Carregar scripts de inicialização, se existir
if [ -f "$HOME/.bash_aliases" ]; then
    . "$HOME/.bash_aliases"  # Carrega aliases adicionais
fi

# Outros comandos a serem executados ao iniciar o shell
# Exemplo: carregar o histórico do terminal
HISTSIZE=1000  # Tamanho máximo do histórico
HISTFILESIZE=2000  # Tamanho máximo do arquivo de histórico
```
### Exemplos de configurações para `.zshrc`

```sh

# .zshrc - Arquivo de configuração do shell Zsh

# Definindo o prompt do shell
PROMPT='%F{green}%n@%m %F{blue}%1~ %F{red}%% %f'  # Formato: [usuário@host diretório]%

# Habilitando cores no terminal
autoload -U colors && colors  # Carrega cores do terminal

# Alias: atalhos para comandos comuns
alias ll='ls -la'  # Lista arquivos com detalhes
alias gs='git status'  # Atalho para verificar o status do Git
alias rm='rm -i'  # Pergunta antes de remover arquivos

# Variáveis de ambiente
export EDITOR='vim'  # Define o editor padrão como vim
export PATH="$PATH:$HOME/bin"  # Adiciona o diretório bin do usuário ao PATH

# Funções personalizadas
mkcd() {
    mkdir -p "$1" && cd "$1"  # Cria um diretório e entra nele
}

# Carregar scripts de inicialização, se existir
if [[ -f "$HOME/.zsh_aliases" ]]; then
    source "$HOME/.zsh_aliases"  # Carrega aliases adicionais
fi

# Configurações do histórico
HISTSIZE=1000  # Tamanho máximo do histórico
SAVEHIST=2000  # Tamanho máximo do arquivo de histórico
HISTFILE=~/.zsh_history  # Arquivo para armazenar o histórico

# Ativar o modo de auto-completar
autoload -Uz compinit && compinit  # Habilita auto-completar para comandos

```
É aí que o meu script entra em cena!
[Aqui está o repositório](https://github.com/bl4ckw1d0w/bwapi.git), onde você pode achar a documentação nescessária para a instalação.

## O que o script faz?

Basicamente, o script compara a versão atual do seu `.bashrc` ou `.zshrc` com uma cópia de backup que ele cria automaticamente. Se houver qualquer alteração, ele registra tudo em um arquivo de log. Assim, você pode ver facilmente o que mudou e, se precisar, reverter para a configuração anterior.

E o melhor de tudo: você pode escolher onde salvar esse log! Se você é como eu e gosta de manter tudo organizado, isso faz uma grande diferença. Além disso, quando você executa o script, ele pergunta se você quer atualizar o backup com a versão atual. Genial, né?


## Como isso ajuda?

Imagine que você fez várias alterações e, de repente, algo começa a dar errado. Com esse script, você pode rapidamente identificar o que mudou e até reverter para a configuração anterior. Isso economiza um tempo precioso e evita frustrações.

Além disso, é uma ótima maneira de documentar seu processo de personalização. Se você está sempre testando novas configurações, ter um histórico de mudanças pode ser super útil. E, claro, você pode compartilhar isso com amigos ou colegas que também ama personalizar seus terminais.


## Ajuda a equipe de segurança ofensiva!

Imagine só: você está lá, testando novas ferramentas e scripts, quando de repente percebe que algo não está certo. Com esse script, você consegue acompanhar todas as alterações feitas nas configurações do seu terminal, o que significa que, se alguém tentar fazer alguma mudança maliciosa, você vai perceber rapidinho.

> ⚠️ Como todos nós sabemos, não é pra isso que vocês vão usar. Então irei reformular:

Com esse script, você pode acompanhar de perto todas as alterações feitas nos arquivos de configuração da máquina monitorada, garantindo que todas as modiificações passem por você. pode ser super útil para descobrir como explorar *o que for nescessário*.
O resto fica com a sua imaginação! 

> ⚠️ **NOTA:** Uso apenas para fins educacionais! 

## Conclusão

No final das contas, a ideia desse projeto é simples, mas pode fazer uma grande diferença na sua rotina. Agora você pode personalizar seu terminal à vontade, sabendo que sempre terá um jeito de acompanhar as mudanças.
