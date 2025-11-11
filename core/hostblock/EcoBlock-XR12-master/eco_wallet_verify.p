#!/usr/bin/env python3
from flask import Blueprint, jsonify, request
import hashlib, os

verify_bp = Blueprint('verify_bp', __name__)

def sha256sum(path):
    h = hashlib.sha256()
    with open(path, 'rb') as f:
        while chunk := f.read(8192):
            h.update(chunk)
    return h.hexdigest()

@verify_bp.route("/", methods=["POST"])
def verify_file():
    data = request.get_json()
    path = data.get("file")
    if not os.path.exists(path):
        return jsonify({"status": "❌ File non trovato", "file": path})
    sha = sha256sum(path)
    return jsonify({"status": "✅ Verifica completata", "file": path, "sha256": sha})
