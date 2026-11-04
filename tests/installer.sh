#!/bin/sh
set -eu
catalog=${1:?Provide the catalog}
installer=${2:-$catalog/scripts/install.sh}
temp=$(mktemp -d)
trap 'rm -rf "$temp"' EXIT
fail() { echo "FAIL: $*" >&2; exit 1; }
for version in 5.1 5.4 8.5; do
    project="$temp/project $version"
    mkdir -p "$project"
    printf '%s\n' 'application-original' > "$project/index.php"
    sh "$installer" --php "$version" --source "$catalog" --project "$project" --smoke
    [ -f "$project/.devcontainer/devcontainer.json" ] || fail 'configuration is missing'
    [ -f "$project/.vscode/launch.json" ] || fail 'debug configuration is missing'
    [ -f "$project/devcontainer-smoke.php" ] || fail 'smoke example is missing'
    [ "$(cat "$project/index.php")" = application-original ] || fail 'application was modified'
    if sh "$installer" --php "$version" --source "$catalog" --project "$project"; then
        fail 'overwrite without --update was accepted'
    fi
    printf '%s\n' 'custom-debug' > "$project/.vscode/launch.json"
    printf '%s\n' 'custom-env' > "$project/.devcontainer/.env"
    printf '%s\n' 'custom-file' > "$project/.devcontainer/custom.txt"
    printf '%s\n' 'old-config' > "$project/.devcontainer/devcontainer.json"
    sh "$installer" --php "$version" --source "$catalog" --project "$project" --update
    [ "$(cat "$project/.vscode/launch.json")" = custom-debug ] || fail 'debug configuration was replaced'
    [ "$(cat "$project/.devcontainer/.env")" = custom-env ] || fail '.env was replaced'
    [ "$(cat "$project/.devcontainer/custom.txt")" = custom-file ] || fail 'custom file was lost'
    [ -f "$project/.devcontainer/launch.template.json" ] || fail 'candidato de debug configuration is missing'
    set -- "$project"/.devcontainer-backup.*
    [ "$(cat "$1/devcontainer/devcontainer.json")" = old-config ] || fail 'invalid backup'
done
mkdir "$temp/invalid" "$temp/symlink"
if sh "$installer" --php 7.4 --source "$catalog" --project "$temp/invalid"; then fail 'invalid version was accepted'; fi
[ ! -e "$temp/invalid/.devcontainer" ] || fail 'partial installation'
ln -s "$temp/invalid" "$temp/symlink/.devcontainer"
if [ -L "$temp/symlink/.devcontainer" ]; then
    if sh "$installer" --php 8.5 --source "$catalog" --project "$temp/symlink" --update; then fail 'symbolic link was accepted'; fi
else
    echo 'SKIP: this environment emulates ln -s with a copy; this scenario requires Linux or native symbolic links.'
fi
mkdir "$temp/root-config"
printf '{}' > "$temp/root-config/.devcontainer.json"
if sh "$installer" --php 8.5 --source "$catalog" --project "$temp/root-config"; then fail 'root configuration was ignored'; fi
echo 'PASS: all three installations, overwrite refusal, backups, file preservation, paths with spaces, and invalid inputs.'
