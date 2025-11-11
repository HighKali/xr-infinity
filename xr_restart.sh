#!/usr/bin/env bash
# xr_restart.sh — Stop pulito + Riavvio XR∞
# Uso: ./xr_restart.sh [ZIP] [PORT]
set -euo pipefail
ZIP="${1:-hostblock.zip}"
PORT="${2:-9090}"

echo "== XR∞ Restart =="
cd "$(dirname "$0")"

echo "🛑 Stop servizi…"
pkill -f "http.server" || true
pkill -f "boinc_bridge.py" || true
pkill -f "seti_ingest.py" || true
sleep 1

echo "🚀 Riavvio con xr_super.sh…"
test -x ./xr_super.sh || { echo "❌ xr_super.sh non trovato o non eseguibile"; exit 1; }
./xr_super.sh "$ZIP" "$PORT"

echo "✅ Dashboard: http://localhost:$PORT/"
