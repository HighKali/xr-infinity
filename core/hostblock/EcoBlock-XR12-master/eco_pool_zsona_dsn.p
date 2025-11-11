from flask import Blueprint, jsonify, request
from datetime import datetime

swap_bp = Blueprint('swap_bp', __name__)

@swap_bp.route("/", methods=["GET"])
def swap_info():
    return jsonify({
        "status": "🟢 Swap attivo",
        "pairs": ["ZSONA/$DSN", "ZSONA/BTC", "ZSONA/XMR"],
        "timestamp": datetime.now().isoformat()
    })

@swap_bp.route("/execute", methods=["POST"])
def swap_execute():
    data = request.get_json()
    from_asset = data.get("from")
    to_asset = data.get("to")
    amount = data.get("amount")
    timestamp = datetime.now().isoformat()

    with open("eco_fusion.log", "a") as log:
        log.write(f"[SWAP] {timestamp} {amount} {from_asset} → {to_asset}\n")

    return jsonify({
        "status": "✅ Swap eseguito",
        "from": from_asset,
        "to": to_asset,
        "amount": amount,
        "timestamp": timestamp
    })
