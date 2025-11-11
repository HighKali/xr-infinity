#!/usr/bin/env python3
from Crypto.Cipher import AES
from Crypto.Random import get_random_bytes
import hashlib, getpass

print("🔐 Backup chiave privata ZSONA")
key = input("Inserisci la tua chiave privata: ")
password = getpass.getpass("🔑 Password di cifratura: ")

# Deriva chiave AES da password
salt = get_random_bytes(16)
aes_key = hashlib.pbkdf2_hmac("sha256", password.encode(), salt, 100000, dklen=32)

# Cifra la chiave privata
cipher = AES.new(aes_key, AES.MODE_EAX)
ciphertext, tag = cipher.encrypt_and_digest(key.encode())

# Salva tutto in wallet_backup.enc
with open("zdos.app/wallet_backup.enc", "wb") as f:
    f.write(salt + cipher.nonce + tag + ciphertext)

print("✅ Backup criptato salvato in zdos.app/wallet_backup.enc")
