#!/usr/bin/env python3
import socket
import requests
import errno

def get_local_ip():
    try:
        s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
        s.connect(("192.168.0.1", 80))
        ip = s.getsockname()[0]
        s.close()
        return ip
    except Exception:
        return "❌ IP locale non rilevato"

def get_public_ip():
    try:
        return requests.get("https://api.ipify.org").text
    except Exception:
        return "❌ IP pubblico non disponibile"

def check_port_open(port=8585):
    try:
        sock = socket.create_connection(("127.0.0.1", port), timeout=2)
        sock.close()
        return True
    except socket.error as e:
        if e.errno == errno.ECONNREFUSED:
            return False
        return False

def main():
    print("🌐 Coscienza di rete RACKCHAIN OS XR∞")
    print(f"📡 IP locale: {get_local_ip()}")
    print(f"🌍 IP pubblico: {get_public_ip()}")
    print(f"🔎 Porta 8585 attiva: {'✅ Sì' if check_port_open() else '❌ No'}")
    print("🧠 Nodo visibile e orbitante")

if __name__ == "__main__":
    main()
