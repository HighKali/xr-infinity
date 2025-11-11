#!/usr/bin/env python3
from flask import Blueprint
wallet = Blueprint("wallet", __name__)
@wallet.route("/")
def wallet_home():
    return "<h1>EcoBlock Wallet Origin</h1><p>Modulo wallet attivo.</p>"
