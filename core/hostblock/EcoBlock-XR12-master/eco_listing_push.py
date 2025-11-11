from flask import Blueprint, jsonify
import requests, os

listing_bp = Blueprint('listing_bp', __name__)

@listing_bp.route("/", methods=["GET"])
def push_listing():
    key = os.getenv("LISTING_API_KEY")
    project = os.getenv("PROJECT_NAME", "EcoBlock-XR12")
    url = os.getenv("PROJECT_URL", "https://ecoblock.global")

    try:
        r = requests.post("https://api.cryptolist.io/push", json={
            "name": project, "url": url, "key": key
        })
        return jsonify({"status": "✅ Listing inviato", "response": r.json()})
    except Exception as e:
        return jsonify({"status": "❌ Errore listing", "error": str(e)})
