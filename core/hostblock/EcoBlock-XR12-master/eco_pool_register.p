from flask import Blueprint, jsonify
import requests, os

register_bp = Blueprint('register_bp', __name__)

@register_bp.route("/register", methods=["GET"])
def register_pool():
    project = os.getenv("PROJECT_NAME", "EcoBlock-XR12")
    url = os.getenv("PROJECT_URL", "https://ecoblock.global")
    hashvault_key = os.getenv("HASHVAULT_API_KEY")
    duino_key = os.getenv("DUINO_API_KEY")
    responses = {}

    try:
        if hashvault_key:
            r = requests.post("https://api.hashvault.pro/register", json={
                "name": project, "url": url, "key": hashvault_key
            })
            responses["hashvault"] = r.json()
        if duino_key:
            r = requests.post("https://server.duinocoin.com/register", json={
                "name": project, "url": url, "key": duino_key
            })
            responses["duino"] = r.json()
    except Exception as e:
        return jsonify({"status": "❌ Errore registrazione", "error": str(e)})

    return jsonify({"status": "✅ Registrazione inviata", "responses": responses})
