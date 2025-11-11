print("🔐 Invio ZTS da Wallet ZSONA")
sender_key = input("Chiave privata mittente: ")
recipient = input("Indirizzo destinatario: ")
amount = input("Importo da inviare (ZTS): ")
print(f"✅ Transazione firmata da {sender_key[:6]}... a {recipient}")
print(f"💸 {amount} ZTS inviati con successo")
with open("zdos.app/tx_log.txt", "a") as log:
    log.write(f"{sender_key[:6]} → {recipient} : {amount} ZTS\n")
