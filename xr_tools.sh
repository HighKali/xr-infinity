#!/usr/bin/env bash
# xr_tools.sh — Utility XR∞: analisi, riparazione, deduplica, sync, merge, report
# Uso: ./xr_tools.sh <comando>
# Comandi: analyze | repair | dedup | sync | merge | report

set -euo pipefail

analyze() {
  echo "🔎 Analisi file corrotti…"
  find . -type f ! -path "./.git/*" -print0 | while IFS= read -r -d '' f; do
    if ! file "$f" >/dev/null 2>&1; then
      echo "⚠️ File non leggibile: $f"
    fi
  done
}

repair() {
  echo "🛠️ Riparazione file testuali…"
  for f in $(find . -type f -name "*.txt" -o -name "*.md"); do
    iconv -f utf-8 -t utf-8 "$f" -o "$f.repaired" 2>/dev/null || true
    if [[ -f "$f.repaired" ]]; then
      mv "$f.repaired" "$f"
      echo "✅ Riparato: $f"
    fi
  done
}

dedup() {
  echo "🧹 Eliminazione duplicati…"
  fdupes -r . | while read -r line; do
    echo "⚠️ Duplicati: $line"
    echo "$line" | awk 'NR>1' | xargs -r rm -f
  done
}

sync() {
  echo "🌐 Sincronizzazione repo…"
  git fetch origin
  git pull origin main --allow-unrelated-histories || true
  git push origin main || true
}

merge() {
  echo "🔀 Merge auto (ours)…"
  git fetch origin
  if ! git pull origin main --allow-unrelated-histories; then
    git checkout --ours .
    git add -A
    git commit -m "XR∞ auto-merge ours"
  fi
  git push origin main
}

report() {
  echo "📊 Genero report JSON con checksum…"
  python3 xr_report.py
}

CMD="${1:-}"
case "$CMD" in
  analyze) analyze ;;
  repair) repair ;;
  dedup) dedup ;;
  sync) sync ;;
  merge) merge ;;
  report) report ;;
  *) echo "Uso: $0 {analyze|repair|dedup|sync|merge|report}" ;;
esac
