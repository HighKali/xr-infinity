#!/usr/bin/env python3
from flask import Blueprint, jsonify
from datetime import datetime

pool_bp = Blueprint('pool_bp', __name__)

@pool_bp.route("/", methods=["GET"])
def pool_status():
    return jsonify({
        "status": "🟢 Pool ZSONA/$DSN attiva",
        "uptime": datetime.now().isoformat(),
        "miners": 12,
        "hashrate": "3.2 GH/s",
        "panel": "/rpc/zsona/pool"
    })
