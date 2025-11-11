#!/usr/bin/env bash
set -euo pipefail
test -f data/sha_manifest.json || { echo "Manifest SHA assente."; exit 0; }
echo "Verifico SHA dai moduli…"
jq -r 'to_entries[] | .key as $mod | .value | to_entries[] | "\($mod) \(.key) \(.value)"' data/sha_manifest.json | \
while read -r mod path sha; do
  if test -f "$path"; then
    cur="$(sha256sum "$path" | awk '{print $1}')"
    [[ "$cur" == "$sha" ]] || echo "⚠️ Mismatch: $path ($mod)"
  else
    echo "⚠️ File mancante: $path ($mod)"
  fi
done
