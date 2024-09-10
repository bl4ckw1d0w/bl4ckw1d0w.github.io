---
layout: post
title: WSL Backup
categories: Linux
description: >-
  Já se deparou com um dilema: Preciso formatar essa máquina, MAS E O MEU LINUX NO WSL? Vou perder todas as configurações!
  Esse artigo vai te ajudar a fazer o backup de TUDO sem complicação.
author: Luana
date: 2024-09-10
categories: [Hellp, Tutorial]
tags: [windows, linux, wsl]
pin: true
media_subpath: '/posts/20240910'
---

# WSL - Backup Passo a Passo

Fazer backup no WSL pode ser uma tarefa fácil e até divertida! Vamos explorar algumas opções passo a passo para garantir a segurança dos seus projetos.

## Opção 1: Git é o Seu Amigo

1. Entre na sua instância WSL.

2. Copie a pasta para o D2

> ⚠️ Mas sério, isso não é muito produtivo.

*Lembrando, pessoal, hoje temos o Git, GitHub, GitLab, Bitbucket e mais! Use o Git para controlar versões e fazer backup dos seus projetos. É fácil, é moderno, é o futuro.*

## Opção 2: Google Drive, Dropbox, ou Similar

1. Se você tem Google Drive ou Dropbox instalados, ótimo!
2. Aponte para a rede como se o WSL2 fosse outro computador.
3. Mas sério, não é a opção mais legal.

## Opção 3: Backup Épico do Linux Inteiro

*Descobri um jeito incrível de fazer backup não só dos seus projetos, mas do Linux inteiro no WSL2. Aqui está como:*

1. Acesse `localState` no seu `AppData`. 
   - Digite `%AppData%` no seu explorador de arquivos.(Pode usar tambem o `CTRL + R` e escrever `%AppData%`)
   - Navegue para `Local\Packages`.

![Alt text](/assets/img/posts/wslbackup_packages.png)

2. Dentro de `localState`, você encontrará um VHDX. Isso é ouro.
 
3. Copie esse VHDX para onde quiser. Formate o Windows, jogue de volta, e pronto!

![Alt text](/assets/img/posts/wslbackup_VHDX.png)

*Sim, você copiou o Linux inteiro. Sem instalação do zero. É incrível, não é?*

## Repositionando o Backup

1. Copiou para algum lugar? Ótimo!
2. Formate sua máquina e baixe a distribuição pelo Windows Store.

3. Instale e inicie pela primeira vez com o mesmo usuário e senha.

4. No PowerShell (não precisa ser administrador), faça um shutdown: `wsl --shutdown`.

5. Sobrescreva o VHDX no caminho: 
   - `C:\Users\SEUUSUARIO\AppData\Local\Packages\PACKAGE DA SUA DISTRIBUIÇÃO\LocalState`.

> ⚠️ **Não tente sobrescrever direto da pasta da nuvem**. Baixe ele no seu computador. **Sério, eu tentei**. Não dá certo😅.

6. Abra o WSL novamente. Tudo pronto!

*Viu como é fácil? Sem resistência, só alegria! Lembre-se, coloque seus projetos aqui, não em `MNT C`. Desenvolvimento no Linux é o futuro. Formate tranquilamente e esteja pronto para programar em questão de horas.*

Aproveite o poder do backup épico! 🚀