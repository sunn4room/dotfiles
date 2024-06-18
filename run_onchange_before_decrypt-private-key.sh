#!/bin/sh

set -e -o pipefail

echo
echo "> decode chezmoi key"

mkdir -p "$HOME/.config/chezmoi"
chezmoi age decrypt --output "$HOME/.config/chezmoi/key.txt" --passphrase "$CHEZMOI_SOURCE_DIR/key.txt.age"
chmod 600 "$HOME/.config/chezmoi/key.txt"
