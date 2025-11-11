# scripts/eco_light_backup.py

import zipfile, os, datetime, hashlib, json, subprocess

# 🔐 Timestamp
stamp = datetime.datetime.now().strftime("%Y%m%d_%H%M%S")
zipname = f"EcoZSONA_{stamp}.zip"

# 📦 Crea ZIP blindato
with zipfile.ZipFile(zipname, 'w', zipfile.ZIP_DEFLATED) as zipf:
    for folder in ['scripts', 'assets']:
        for root, _, files in os.walk(folder):
            for file in files:
                if any(x in file for x in ['.zip', '.DS_Store']) or '__pycache__' in root:
                    continue
                path = os.path.join(root, file)
                zipf.write(path)

    for file in ['rackchain.html', 'README.md']:
        if os.path.exists(file):
            zipf.write(file)

# 🔐 Calcola SHA256
def sha256sum(filename):
    h = hashlib.sha256()
    with open(filename, 'rb') as f:
        while chunk := f.read(8192):
            h.update(chunk)
    return h.hexdigest()

signature = sha256sum(zipname)

# 🧠 Log firma
with open("eco_light_sign.py", "a") as f:
    f.write(f"# 🔐 {zipname} → SHA256: {signature}\n")

# 🧠 Log backup
with open("eco_log.py", "a") as f:
    f.write(f"# ✅ Backup creato: {zipname} | SHA256: {signature}\n")

# 📤 Notifica simulata
notify = {
    "status": "EcoZSONA Backup",
    "file": zipname,
    "sha256": signature,
    "timestamp": stamp
}
print("📤 Notifica inviata:")
print(json.dumps(notify, indent=2))

# 🚀 GitHub push (se repo esiste)
if os.path.isdir(".git"):
    subprocess.run(["git", "add", zipname])
    subprocess.run(["git", "commit", "-m", f"🔐 Backup {zipname}"])
    subprocess.run(["git", "push"])
else:
    print("⚠️ Git non inizializzato. Salta push.")

# 🌐 IPFS (simulato)
print(f"🌐 IPFS hash simulato: Qm{signature[:44]}")
