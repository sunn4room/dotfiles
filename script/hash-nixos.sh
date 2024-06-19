#!/bin/sh

list_nix() {
	if echo "$1" | grep -q -E '^\./.*'; then
		set -- "${1:2}"
	fi
	if echo "$1" | grep -q -E -v '.*\.nix$'; then
		set -- "$1/default.nix"
	fi
	if test -f "${FILE}"; then
		return
	fi
	echo "$1"
	local DIR
	sed -n '/^  imports = \[$/,/^  \];$/p' "$1" | sed '1d;$d;s#^    \./##' | while read line; do
		list_nix "$(dirname $1)/${line}"
	done
}

cd "${CHEZMOI_SOURCE_DIR}/nixos"

list_nix "$1.nix" | xargs -d "\n" sha256sum
