#!/bin/bash

echo "🚀 Avvio EcoBlock XR12..."
PORT=8080
LOG="eco_fusion.log"
MASTER="eco_xr12_master.py"

# Controllo porta
echo "[CHECK] Verifica porta $PORT..."
if lsof -i:$PORT >/dev/null; then
  echo "❌ Porta $PORT già in uso. Interrompi e riprova."
  exit 1
fi

# Avvio master
echo "[START] Avvio master..."
nohup python3 $MASTER > /dev/null 2>&1 &
sleep 2

# Firma con ignite (opzionale)
if [ -f eco_ignite.py ]; then
  echo "[SIGN] Firma con eco_ignite.py..."
  python3 eco_ignite.py
else
  echo "[WARN] eco_ignite.py non trovato"
fi

# Registrazione mining pool
echo "[POOL] Registrazione in corso..."
curl -s http://127.0.0.1:$PORT/rpc/zsona/pool_register/register

# Listing automatico
echo "[LISTING] Invio dati a directory..."
curl -s http://127.0.0.1:$PORT/rpc/zsona/listing

# Log finale
echo "[LOG] Scrittura log..."
echo "[LAUNCH] $(date +%Y-%m-%dT%H:%M:%S) → Avvio completato su porta $PORT" >> $LOG

# Output finale
echo "✅ Suite XR12 avviata e registrata."
echo "🌐 Dashboard: http://127.0.0.1:$PORT/"
