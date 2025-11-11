#!/usr/bin/env python3
from flask import Blueprint
pool = Blueprint("pool", __name__)
@pool.route("/pool")
def pool_home():
    return "<h1>EcoBlock Pool ZSONA/$DSN</h1><p>Modulo pool attivo.</p>"
