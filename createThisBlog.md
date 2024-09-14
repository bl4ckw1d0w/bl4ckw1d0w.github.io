# Instalando Jekyll e configurando o tema Chirpy

## Instalar dependências:

sudo apt-get update
sudo apt-get install ruby-full build-essential zlib1g-dev

## Configurar o RubyGems:

echo '# Install Ruby Gems to ~/gems' >> ~/.bashrc
echo 'export GEM_HOME="$HOME/gems"' >> ~/.bashrc
echo 'export PATH="$HOME/gems/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc

## Instalar Jekyll e Bundler:
gem install jekyll bundler

## Criar um novo site Jekyll:
jekyll new myblog
cd myblog

## Adicionar o tema Chirpy:
Clone o repositório do tema Chirpy:
git clone https://github.com/cotes2020/jekyll-theme-chirpy.git

## Copie os arquivos do tema para o seu projeto:
cp -r jekyll-theme-chirpy/* .

## Configurar o GitHub Pages:
### Crie um repositório no GitHub com o nome USERNAME.github.io.
### Adicione o repositório remoto e faça o push:
git init
git remote add origin https://github.com/USERNAME/USERNAME.github.io.git
git add .
git commit -m "Initial commit"
git push -u origin main

## Configurar o GitHub Pages:
Vá para as configurações do repositório no GitHub.
Em “Pages”, selecione a branch main e a pasta / (root).