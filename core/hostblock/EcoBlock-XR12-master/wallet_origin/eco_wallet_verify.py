#!/usr/bin/env python3
from flask import Blueprint
verify = Blueprint("verify", __name__)
@verify.route("/verify")
def verify_home():
    return "<h1>EcoBlock Verifica SHA256</h1><p>Modulo verifica attivo.</p>"
