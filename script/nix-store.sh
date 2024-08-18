#!/usr/bin/env sh

set -e

test -n "$1"
target="$(which "$1")"
while test -L "${target}"; do
  target="$(readlink "${target}")"
done
expr "${target}" : "/nix/store/" >/dev/null 2>&1
printf '%s' "${target}" | cut -d'/' -f1,2,3,4
