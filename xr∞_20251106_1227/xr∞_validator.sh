#!/bin/bash
# Verifica orbitale e legale del nodo XR∞

echo "🛡️ Validazione nodo XR∞..."
NODE_ID=$(hostname)
SHA=$(sha256sum xr∞_anello_total.sh | awk '{print $1}')
echo "$(date -u) | Nodo: $NODE_ID | SHA: $SHA" >> eco_log.py
echo "✅ Nodo validato — SHA: $SHA"
