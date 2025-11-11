#!/usr/bin/env python3
from flask import Blueprint, Response
from datetime import datetime

badge_bp = Blueprint('badge_bp', __name__)

@badge_bp.route("/", methods=["GET"])
def badge_svg():
    timestamp = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    svg = f'''
    <svg width="300" height="100" xmlns="http://www.w3.org/2000/svg">
      <rect width="300" height="100" fill="black"/>
      <text x="150" y="55" font-size="18" fill="#00FFAA" text-anchor="middle" font-family="monospace">
        🟢 EcoBlock XR12 — {timestamp}
      </text>
    </svg>
    '''
    return Response(svg, mimetype='image/svg+xml')
