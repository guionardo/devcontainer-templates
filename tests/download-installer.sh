#!/bin/sh
set -eu
installer=${1:?Provide the script}
temp=$(mktemp -d)
trap 'rm -rf "$temp"' EXIT
mkdir "$temp/project"
sh "$installer" --php 5.4 --project "$temp/project" --ref 318d7523ce99a64e4371bd7f4de4a418d132cb1b
grep -q '^revision=318d7523ce99a64e4371bd7f4de4a418d132cb1b$' "$temp/project/.devcontainer/template-source.txt"
test -f "$temp/project/.devcontainer/compose.yaml"
echo 'PASS: Git download by SHA, installation, and revision recording.'
