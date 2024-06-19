#!/bin/sh

TMP="$(mktemp)"
cd "${CHEZMOI_SOURCE_DIR}"
git ls-files >> "${TMP}"
git ls-files -d >> "${TMP}"
git ls-files -o >> "${TMP}"
sort "${TMP}" | uniq -u | xargs -d "\n" sha256sum
rm "${TMP}"
