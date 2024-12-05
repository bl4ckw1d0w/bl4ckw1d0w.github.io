#!/usr/bin/env bash
#
# Build and test the site content
#
# Requirement: html-proofer, jekyll
#
# Usage: See help information

set -eu

SITE_DIR="_site"

_config="_config.yml"

_baseurl=""

help() {
  echo "Build and test the site content"
  echo
  echo "Usage:"
  echo
  echo "   bash ./tools/test [options]"
  echo
  echo "Options:"
  echo '     -c, --config   "<config_a[,config_b[...]]>"    Specify config file(s)'
  echo "     -h, --help               Print this information."
}

read_baseurl() {
  if [[ $_config == *","* ]]; then
    # multiple config
    IFS=","
    read -ra config_array <<<"$_config"

    # reverse loop the config files
    for ((i = ${#config_array[@]} - 1; i >= 0; i--)); do
      _tmp_baseurl="$(grep '^baseurl:' "${config_array[i]}" | sed "s/.*: *//;s/['\"]//g;s/#.*//")"

      if [[ -n $_tmp_baseurl ]]; then
        _baseurl="$_tmp_baseurl"
        break
      fi
    done

  else
    # single config
    _baseurl="$(grep '^baseurl:' "$_config" | sed "s/.*: *//;s/['\"]//g;s/#.*//")"
  fi
}

main() {
  # clean up
  if [[ -d $SITE_DIR ]]; then
    rm -rf "$SITE_DIR"
  fi

  read_baseurl

  echo "Base URL: $_baseurl"

  # build
  JEKYLL_ENV=production bundle exec jekyll b \
    -d "$SITE_DIR$_baseurl" -c "$_config"

  echo "Site built at: $SITE_DIR$_baseurl"
  echo "Contents of $SITE_DIR:"
  ls -R "$SITE_DIR"

  # Verificar se os diretórios de categorias e tags foram gerados corretamente
  echo "Contents of $SITE_DIR/categories:"
  ls -R "$SITE_DIR/categories" || echo "No categories directory found"

  echo "Contents of $SITE_DIR/tags:"
  ls -R "$SITE_DIR/tags" || echo "No tags directory found"
  
  # test
  bundle exec htmlproofer "$SITE_DIR" \
    --ignore-urls "/^http:\/\/127.0.0.1/,/^http:\/\/0.0.0.0/,/^http:\/\/localhost/,/^https:\/\/fonts.googleapis.com/,/^https:\/\/fonts.gstatic.com/,/^https:\/\/twitter.com\/twitter_username/,/^https:\/\/www.linkedin.com\/in\/black-widow/,/^https:\/\/blackwidow.com.br\/categories\/ferramentas\//,/^https:\/\/blackwidow.com.br\/categories\/pipeline\//,/^https:\/\/blackwidow.com.br\/categories\/tutoriais\//,/^https:\/\/blackwidow.com.br\/posts\/go-docker-action\//,/^https:\/\/blackwidow.com.br\/tags\/automacao\//,/^https:\/\/blackwidow.com.br\/tags\/backup\//,/^https:\/\/blackwidow.com.br\/tags\/github-actions\//,/^https:\/\/blackwidow.com.br\/tags\/go\//,/^https:\/\/blackwidow.com.br\/tags\/logs\//,/^https:\/\/blackwidow.com.br\/tags\/monitoramento\//,/^https:\/\/blackwidow.com.br\/categories\/eventos\//,/^https:\/\/blackwidow.com.br\/categories\/seguran%C3%A7a\//,/^https:\/\/blackwidow.com.br\/posts\/nullbyte-10anos\//,/^https:\/\/blackwidow.com.br\/tags\/nullbyte\//" \
    || { echo "htmlproofer found issues"; exit 1; }


while (($#)); do
  opt="$1"
  case $opt in
  -c | --config)
    _config="$2"
    shift
    shift
    ;;
  -h | --help)
    help
    exit 0
    ;;
  *)
    # unknown option
    help
    exit 1
    ;;
  esac
done

main