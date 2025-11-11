#!/usr/bin/env python3
from flask import Blueprint
swap = Blueprint("swap", __name__)
@swap.route("/swap")
def swap_home():
    return "<h1>EcoBlock Swap Panel</h1><p>Modulo swap attivo.</p>"
