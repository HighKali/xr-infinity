#!/bin/bash

echo "🚀 Avvio completo EcoBlock XR12..."
PORT=8080
LOG="eco_fusion.log"
MASTER="eco_xr12_master.py"

# 1. Chiudi eventuali istanze precedenti
echo "[KILL] Terminazione master precedente..."
pkill -f $MASTER
sleep 1

# 2. Avvio master
echo "[START] Avvio master..."
nohup python3 $MASTER > /dev/null 2>&1 &
sleep 2

# 3. Firma con eco_ignite.py
if [ -f eco_ignite.py ]; then
  echo "[SIGN] Firma con eco_ignite.py..."
  python3 eco_ignite.py
else
  echo "[WARN] eco_ignite.py non trovato"
fi

# 4. Registrazione mining pool
echo "[POOL] Registrazione in corso..."
POOL_RESPONSE=$(curl -s http://127.0.0.1:$PORT/rpc/zsona/pool_register/register)
echo "$POOL_RESPONSE" | grep -q "✅" && echo "✅ Pool registrata" || echo "❌ Errore pool"

# 5. Listing automatico
echo "[LISTING] Invio dati a directory..."
LISTING_RESPONSE=$(curl -s http://127.0.0.1:$PORT/rpc/zsona/listing/)
echo "$LISTING_RESPONSE" | grep -q "✅" && echo "✅ Listing completato" || echo "⚠️ Listing disattivato o fallito"

# 6. Scrittura log
echo "[LOG] Scrittura log..."
echo "[LAUNCH] $(date +%Y-%m-%dT%H:%M:%S) → Avvio completato su porta $PORT" >> $LOG

# 7. Output finale
echo "✅ Suite XR12 avviata e firmata."
echo "🌐 Dashboard: http://127.0.0.1:$PORT/"
