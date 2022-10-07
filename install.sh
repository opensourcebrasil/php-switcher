#!/usr/bin/env sh
# Copyright 2022 Kaio Piola / Open Source Brasil. GPL license.
# Edited from project Denoland install script (https://github.com/denoland/deno_install)

set -e

case $(uname -sm) in
	"Linux x86_64") target="linux-amd64" ;;
	"Linux aarch64") target="linux-arm64" ;;
	*) echo "Plataforma $(uname -sm) não suportada. Apenas x86_64 e arm64 para Linux estão disponíveis."; exit ;;
esac

# check for dependencies
command -v curl >/dev/null || { echo "curl não está instalado\!" >&2; exit 1; }
command -v tar >/dev/null || { echo "tar não está instalado\!" >&2; exit 1; }
command -v grep >/dev/null || { echo "grep não está instalado\!" >&2; exit 1; }

# download uri
releases_uri=https://github.com/opensourcebrasil/php-switcher/releases
if [ $# -gt 0 ]; then
	tag=$1
else
	tag=$(curl -LsH 'Accept: application/json' $releases_uri/latest)
	tag=${tag%\,\"update_url*}
	tag=${tag##*tag_name\":\"}
	tag=${tag%\"}
fi

tag=${tag#v}

echo "DEFININDO Versão $tag"

download_uri=$releases_uri/download/v$tag/phpswitcher-$tag.tar.gz

# locations
phpswitcher_install="/usr/bin"
download_folder="/tmp"
exe="$phpswitcher_install/phpswitcher"
tar="$download_folder/phpswitcher.tar.gz"

# installing
echo "BAIXANDO $download_uri"
curl --fail --location --progress-bar --output "$tar" "$download_uri"

echo "EXTRAINDO $tar"
tar xzf "$tar" -C "$phpswitcher_install"

echo "CONFIGURANDO PERMISSÕES EXECUTAVEIS PARA $exe"
#chmod -x "$exe"
chmod 777 "$exe"

echo "REMOVENDO $tar"
rm "$tar"


echo
echo "phpswitcher v$tag foi instalado com sucesso em $phpswitcher_install"
