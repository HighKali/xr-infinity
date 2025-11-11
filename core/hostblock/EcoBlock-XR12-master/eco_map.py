#!/usr/bin/env python3
from flask import Blueprint, jsonify

map_bp = Blueprint('map_bp', __name__)

@map_bp.route("/", methods=["GET"])
def map_data():
    return jsonify({
        "status": "🗺️ Mappa orbitale attiva",
        "zones": ["ZONA1", "ZONA2", "ZONA3"],
        "laser": True,
        "style": "neon"
    })
