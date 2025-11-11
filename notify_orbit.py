#!/usr/bin/env python3
# Notifica Telegram/Matrix — modulo base

import sys, requests

def send(msg):
    url = "https://api.telegram.org/bot<YOUR_TOKEN>/sendMessage"
    payload = {"chat_id": "<YOUR_CHAT_ID>", "text": msg}
    requests.post(url, data=payload)

if __name__ == "__main__":
    send(" ".join(sys.argv[2:]))
