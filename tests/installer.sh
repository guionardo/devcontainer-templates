#!/bin/sh
set -eu
catalog=${1:?Informe o catálogo}
installer=${2:-$catalog/scripts/install.sh}
temp=$(mktemp -d)
trap 'rm -rf "$temp"' EXIT
fail() { echo "FAIL: $*" >&2; exit 1; }
for version in 5.1 5.4 8.5; do
    project="$temp/project $version"
    mkdir -p "$project"
    printf '%s\n' 'application-original' > "$project/index.php"
    sh "$installer" --php "$version" --source "$catalog" --project "$project" --smoke
    [ -f "$project/.devcontainer/devcontainer.json" ] || fail 'config ausente'
    [ -f "$project/.vscode/launch.json" ] || fail 'debug ausente'
    [ -f "$project/devcontainer-smoke.php" ] || fail 'smoke ausente'
    [ "$(cat "$project/index.php")" = application-original ] || fail 'aplicação modificada'
    if sh "$installer" --php "$version" --source "$catalog" --project "$project"; then
        fail 'sobrescrita sem --update aceita'
    fi
    printf '%s\n' 'custom-debug' > "$project/.vscode/launch.json"
    printf '%s\n' 'custom-env' > "$project/.devcontainer/.env"
    printf '%s\n' 'custom-file' > "$project/.devcontainer/custom.txt"
    printf '%s\n' 'old-config' > "$project/.devcontainer/devcontainer.json"
    sh "$installer" --php "$version" --source "$catalog" --project "$project" --update
    [ "$(cat "$project/.vscode/launch.json")" = custom-debug ] || fail 'debug substituído'
    [ "$(cat "$project/.devcontainer/.env")" = custom-env ] || fail '.env substituído'
    [ "$(cat "$project/.devcontainer/custom.txt")" = custom-file ] || fail 'personalização perdida'
    [ -f "$project/.devcontainer/launch.template.json" ] || fail 'candidato de debug ausente'
    set -- "$project"/.devcontainer-backup.*
    [ "$(cat "$1/devcontainer/devcontainer.json")" = old-config ] || fail 'backup inválido'
done
mkdir "$temp/invalid" "$temp/symlink"
if sh "$installer" --php 7.4 --source "$catalog" --project "$temp/invalid"; then fail 'versão inválida aceita'; fi
[ ! -e "$temp/invalid/.devcontainer" ] || fail 'instalação parcial'
ln -s "$temp/invalid" "$temp/symlink/.devcontainer"
if [ -L "$temp/symlink/.devcontainer" ]; then
    if sh "$installer" --php 8.5 --source "$catalog" --project "$temp/symlink" --update; then fail 'symlink aceito'; fi
else
    echo 'SKIP: este ambiente emula ln -s com uma cópia; o cenário de symlink exige Linux ou symlinks nativos.'
fi
mkdir "$temp/root-config"
printf '{}' > "$temp/root-config/.devcontainer.json"
if sh "$installer" --php 8.5 --source "$catalog" --project "$temp/root-config"; then fail 'config raiz ignorada'; fi
echo 'PASS: instalação nas três versões, recusa de sobrescrita, backup, preservação de arquivos, caminhos com espaços e entradas inválidas.'
