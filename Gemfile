# frozen_string_literal: true

# Define o repositório de gems
source "https://rubygems.org"

# Carrega a especificação do gemspec
gemspec

# Adiciona a gem 'html-proofer' apenas para o grupo de testes
gem "html-proofer", "~> 5.0", group: :test

# Adiciona dependências específicas para plataformas Windows
platforms :mingw, :x64_mingw, :mswin, :jruby do
  gem "tzinfo", ">= 1", "< 3"
  gem "tzinfo-data"
end

# Adiciona a gem 'wdm' para Windows
gem "wdm", "~> 0.1.1", platforms: [:mingw, :x64_mingw, :mswin]