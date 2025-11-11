#!/usr/bin/env python3
from flask import Blueprint, jsonify, request
import hashlib, os
from datetime import datetime

wallet_bp = Blueprint('wallet_bp', __name__)

WALLET_PATH = "eco_wallet_zsona_origin.json"

def sha256sum(path):
    h = hashlib.sha256()
    with open(path, 'rb') as f:
        while chunk := f.read(8192):
            h.update(chunk)
    return h.hexdigest()

@wallet_bp.route("/", methods=["GET"])
def wallet_status():
    if os.path.exists(WALLET_PATH):
        sha = sha256sum(WALLET_PATH)
        return jsonify({
            "status": "🟢 Wallet ZSONA attivo",
            "file": WALLET_PATH,
            "sha256": sha,
            "timestamp": datetime.now().isoformat()
        })
    else:
        return jsonify({
            "status": "🔴 Wallet non trovato",
            "file": WALLET_PATH,
            "message": "Assicurati che il file sia presente nella directory"
        })

@wallet_bp.route("/receive", methods=["POST"])
def wallet_receive():
    data = request.get_json()
    sender = data.get("from")
    amount = data.get("amount")
    asset = data.get("asset", "ZSONA")
    timestamp = datetime.now().isoformat()

    log_entry = f"[RECEIVE] {timestamp} ← {amount} {asset} da {sender}\n"
    with open("eco_fusion.log", "a") as log:
        log.write(log_entry)

    return jsonify({
        "status": "✅ Ricezione registrata",
        "from": sender,
        "amount": amount,
        "asset": asset,
        "timestamp": timestamp
    })
