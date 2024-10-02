---
layout: post
title: "GitHub CLI: O Superpoder que Você Não Sabia Que Precisava!"
categories: [DevOps, Git]
tags: [github, cli, automação, terminal, workflow, produtividade]
---

# GitHub CLI: O Superpoder que Você Não Sabia Que Precisava!

Eu estava fuçando na internet e lembrei de uma ferramenta que eu usei uma vez na vida e nunca mais. Resolvi mostrar ela pra vocês aqui. Você já ficou cansado de ir no navegador toda vez que precisa fazer alguma coisa no GitHub, parabéns! **Seus problemas acabaram**. Chegou o GitHub CLI, um jeito esperto (e estiloso!) de interagir com seus repositórios sem sair do terminal.

## Que raios é o GitHub CLI?

GitHub CLI é o comando mágico que coloca o GitHub direto no seu terminal. Quer fazer um pull request? **CLI.** Precisa ver suas issues? **CLI.** Quer uma lista de seus repositórios favoritos? **Adivinha? CLI!**. Basicamente, ele é o seu atalho para não precisar abrir o navegador e passar pelo labirinto de cliques até chegar onde quer.

## Como instalar?
A boa notícia é que o GitHub CLI está disponível para praticamente qualquer sistema operacional. Veja abaixo como instalar no seu:

- **No macOS:**
Se você usa o Homebrew, o processo é super simples. Basta rodar:

```bash
brew install gh
```
- **No Windows**:
Você pode instalar o GitHub CLI através do winget (Windows Package Manager). O comando é o seguinte:

```bash
winget install --id GitHub.cli
```
Ou você pode usar o instalador MSI direto da página oficial do GitHub CLI.

- **No Linux:**
Dependendo da sua distro, você pode usar o gerenciador de pacotes nativo. Por exemplo, no Ubuntu/Debian:

```bash
sudo apt install gh
```
Para outras distros, consulte a [documentação oficial do GitHub CLI](https://cli.github.com/) para ver os detalhes.

## Como usar?

Muito simples! Depois de instalar (o que é fácil, porque tem pra tudo quanto é sistema operacional), você loga na sua conta GitHub pelo terminal com o comando:

```bash
gh auth login
```

Agora você está livre para explorar o poder da CLI! Vamos ver alguns comandos legais:

- **Listar seus repositórios:**
  ```bash
  gh repo list
  ```

- **Criar uma issue:**
  ```bash
  gh issue create
  ```

- **Fazer um pull request:**
  ```bash
  gh pr create
  ```

Ou seja, praticamente tudo o que você faria pelo site, mas com o bônus de parecer um hacker invadindo a NASA (brincadeira, não façam isso).

## Com que devo me preocupar:

### Os Prós

1. **Economia de tempo:** Você não precisa sair do terminal, o que é ótimo pra quem está no meio da produtividade e não quer perder o foco.
2. **Automação fácil:** Você consegue *scriptar* uma série de comandos e deixar seu workflow afiado.
3. **Poder do terminal:** Todo o charme do terminal, mas com a eficiência do GitHub integrado. Quem não gosta?
4. **Funcionalidades avançadas:** Além do básico, você pode fazer reviews de PRs, rodar ações, e muito mais, direto do terminal.

### Os Contras

1. **Curva de aprendizado:** Não vou mentir, no começo pode ser meio confuso se acostumar com os comandos, especialmente se você não é tão familiarizado com terminal.
2. **Nem tudo dá pra fazer:** Ainda tem algumas coisas que só o site te deixa fazer, tipo aquelas configurações avançadas do repo.
3. **Ficar perdido no terminal:** Se você é daqueles que se perdem fácil em várias abas do terminal, prepare-se pra navegar bem entre elas!

## **Mas não se esqueça da segurança!**

Mesmo usando o GitHub CLI, **não dá para deixar de lado boas práticas de segurança**, especialmente se você está colaborando em equipe. Aqui vão duas dicas fundamentais:

- [**Use SSH para autenticação**](https://docs.github.com/pt/authentication/connecting-to-github-with-ssh): SSH é mais seguro do que HTTPS porque cria uma conexão criptografada e elimina a necessidade de inserir suas credenciais repetidamente. Se você ainda não configurou o SSH, faça isso para garantir que suas interações com o GitHub sejam seguras.
[Conectar-se ao GitHub com o SSH]
  
- [**Assine seus commits com GPG**](https://docs.github.com/pt/authentication/managing-commit-signature-verification/signing-commits): Para garantir que seus colegas (ou a comunidade open-source) possam confiar que os commits foram realmente **feitos por você**, configure a assinatura GPG dos seus commits. Isso é crucial em projetos colaborativos e evita que outra pessoa finja ser você ao contribuir com o código.

Para configurar, use:

```bash
git config --global commit.gpgSign true
```

Assim, você reforça a segurança dos seus commits e mantém um ambiente confiável, mesmo trabalhando em grandes equipes.

#### Conclusão

GitHub CLI é aquele tipo de ferramenta que você não sabia que precisava, mas depois que começa a usar, não quer mais largar. Claro, tem seus contras, mas os prós valem muito a pena se você quer deixar seu fluxo de trabalho mais eficiente e estiloso.

**E lembre-se, por mais incrível que seja o GitHub CLI, não deixe de configurar o SSH e assinar seus commits com GPG para garantir a segurança do seu código.**

Vai lá, dá uma chance! Arrasta pra cima pra mais dicas heehh.

---