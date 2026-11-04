#!/bin/sh
# Run with: sh install.sh --php 5.4 --project /path/to/project
set -eu

usage() {
    cat <<'EOF'
Uso: sh install.sh --php 5.1|5.4|8.5 [opções]
  --project DIR   Projeto existente (padrão: diretório atual)
  --ref REF       Branch, tag ou SHA do catálogo (padrão: main)
  --update        Atualiza arquivos do template, criando backup antes
  --smoke         Inclui o exemplo devcontainer-smoke.php se não existir
  --source DIR    Usa um catálogo local em vez de baixar pelo Git
  --help          Mostra esta ajuda

Requer Git e ferramentas POSIX. Compatível com Git Bash, WSL, Linux e macOS.
Não inicia containers. launch.json existente é preservado para mescla manual.
EOF
}
fail() { printf 'Erro: %s\n' "$*" >&2; exit 1; }
php_version= project=. ref=main update=false smoke=false source_dir= temp_dir=
while [ "$#" -gt 0 ]; do
    case "$1" in
        --php|--project|--ref|--source)
            [ "$#" -ge 2 ] && [ -n "$2" ] || fail "Falta valor para $1"
            case "$1" in
                --php) php_version=$2 ;;
                --project) project=$2 ;;
                --ref) ref=$2 ;;
                --source) source_dir=$2 ;;
            esac
            shift 2 ;;
        --update) update=true; shift ;;
        --smoke) smoke=true; shift ;;
        --help|-h) usage; exit 0 ;;
        *) fail "Argumento desconhecido: $1" ;;
    esac
done
case "$php_version" in
    5.1|5.1.6) template=php-5.1.6; port=8051 ;;
    5.4|5.4.45) template=php-5.4; port=8054 ;;
    8.5) template=php-8.5; port= ;;
    *) usage >&2; fail 'Informe --php 5.1, 5.4 ou 8.5' ;;
esac
case "$ref" in ''|-*|*[!a-zA-Z0-9._/-]*) fail 'Referência Git inválida' ;; esac
[ -d "$project" ] || fail "Projeto inexistente: $project"
case "$project" in /*) ;; *) project=./$project ;; esac
project=$(CDPATH= cd "$project" && pwd -P)
[ ! -e "$project/.devcontainer.json" ] && [ ! -L "$project/.devcontainer.json" ] || fail 'Existe .devcontainer.json na raiz; integre essa configuração manualmente.'
for relative in .devcontainer .vscode .vscode/launch.json devcontainer-smoke.php \
    .devcontainer/devcontainer.json .devcontainer/Dockerfile .devcontainer/compose.yaml \
    .devcontainer/.env .devcontainer/template-source.txt .devcontainer/launch.template.json; do
    [ ! -L "$project/$relative" ] || fail "Caminho simbólico não suportado: $relative"
done
for relative in .devcontainer .vscode; do
    [ ! -e "$project/$relative" ] || [ -d "$project/$relative" ] || fail "$relative deve ser uma pasta"
done
if [ -e "$project/.devcontainer" ] && [ "$update" = false ]; then
    fail 'O projeto já tem .devcontainer. Revise a configuração e use --update para atualizar com backup.'
fi
cleanup() { if [ -n "$temp_dir" ]; then rm -rf "$temp_dir"; fi; }
trap cleanup EXIT
trap 'exit 130' INT
trap 'exit 143' TERM
if [ -n "$source_dir" ]; then
    [ -d "$source_dir" ] || fail 'Catálogo local inexistente'
    case "$source_dir" in /*) ;; *) source_dir=./$source_dir ;; esac
    source_dir=$(CDPATH= cd "$source_dir" && pwd -P)
    revision=local
else
    command -v git >/dev/null 2>&1 || fail 'Instale Git antes de executar o instalador'
    temp_dir=$(mktemp -d)
    git -C "$temp_dir" init -q
    git -C "$temp_dir" remote add origin https://github.com/guionardo/devcontainer-templates.git
    git -C "$temp_dir" fetch -q --depth=1 origin "$ref"
    git -C "$temp_dir" checkout -q --detach FETCH_HEAD
    source_dir=$temp_dir
    revision=$(git -C "$temp_dir" rev-parse HEAD)
fi
source_template=$source_dir/src/$template
for relative in .devcontainer/devcontainer.json .devcontainer/Dockerfile .vscode/launch.json; do
    [ -f "$source_template/$relative" ] || fail "Template incompleto: $relative"
done
if [ -n "$port" ]; then
    [ -f "$source_template/.devcontainer/compose.yaml" ] || fail 'Template sem compose.yaml'
fi
if [ "$smoke" = true ]; then
    [ -f "$source_template/devcontainer-smoke.php" ] || fail 'Template sem smoke test'
fi
# Validate destination types before modifying anything.
for relative in .devcontainer/devcontainer.json .devcontainer/Dockerfile .devcontainer/compose.yaml \
    .devcontainer/.env .devcontainer/template-source.txt .devcontainer/launch.template.json .vscode/launch.json; do
    [ ! -e "$project/$relative" ] || [ -f "$project/$relative" ] || fail "Destino deve ser arquivo: $relative"
done
backup=
if [ "$update" = true ] && [ -d "$project/.devcontainer" ]; then
    backup=$(mktemp -d "$project/.devcontainer-backup.XXXXXX")
    cp -R "$project/.devcontainer" "$backup/devcontainer"
    if [ -f "$project/.vscode/launch.json" ]; then
        cp "$project/.vscode/launch.json" "$backup/launch.json"
    fi
    printf 'Backup: %s\n' "$backup"
fi
mkdir -p "$project/.devcontainer" "$project/.vscode"
# Only overwrite known template files; preserve .env and custom files.
for filename in devcontainer.json Dockerfile compose.yaml; do
    if [ -f "$source_template/.devcontainer/$filename" ]; then
        cp "$source_template/.devcontainer/$filename" "$project/.devcontainer/$filename"
    fi
done
if [ -e "$project/.vscode/launch.json" ]; then
    cp "$source_template/.vscode/launch.json" "$project/.devcontainer/launch.template.json"
    printf '%s\n' 'launch.json preservado. Mescle configurations de .devcontainer/launch.template.json no launch.json existente.'
else
    cp "$source_template/.vscode/launch.json" "$project/.vscode/launch.json"
fi
if [ -n "$port" ] && [ ! -e "$project/.devcontainer/.env" ]; then
    project_name=$(basename "$project" | tr '[:upper:]' '[:lower:]' | tr -c 'a-z0-9_-' '-')
    unique=$(mktemp -d)
    suffix=$(basename "$unique" | tr -cd 'a-zA-Z0-9' | tr '[:upper:]' '[:lower:]')
    rmdir "$unique"
    printf 'COMPOSE_PROJECT_NAME=php-%s-%s\nPHP_HTTP_PORT=%s\n' "$project_name" "$suffix" "$port" > "$project/.devcontainer/.env"
fi
if [ "$smoke" = true ] && [ ! -e "$project/devcontainer-smoke.php" ]; then
    cp "$source_template/devcontainer-smoke.php" "$project/devcontainer-smoke.php"
fi
printf 'template=%s\nref=%s\nrevision=%s\n' "$template" "$ref" "$revision" > "$project/.devcontainer/template-source.txt"
printf '\nTemplate %s aplicado em %s\n' "$template" "$project"
printf '%s\n' 'Abra o projeto no VS Code e execute Dev Containers: Reopen in Container.'
if [ "$update" = true ]; then
    printf '%s\n' 'Revise o diff e execute Dev Containers: Rebuild Container. Arquivos personalizados e .env foram preservados.'
fi
if [ -n "$port" ]; then
    printf '%s\n' 'Confira PHP_HTTP_PORT em .devcontainer/.env; projetos simultâneos precisam de portas diferentes.'
fi
