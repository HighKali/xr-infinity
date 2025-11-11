#!/usr/bin/env python3
from flask import Blueprint, jsonify

ui_bp = Blueprint('ui_bp', __name__)

@ui_bp.route("/", methods=["GET"])
def ui_status():
    return jsonify({
        "status": "🟢 Interfaccia LED attiva",
        "theme": "retro neon",
        "panels": ["wallet", "pool", "swap", "map", "badge"]
    })
