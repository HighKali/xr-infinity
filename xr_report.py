# xr_report.py — genera report JSON con checksum SHA256 e duplicati
import os, hashlib, json

def sha256sum(path):
    h = hashlib.sha256()
    with open(path,'rb') as f:
        for chunk in iter(lambda: f.read(8192), b''):
            h.update(chunk)
    return h.hexdigest()

files = []
for root, dirs, fs in os.walk('.'):
    if '.git' in root: continue
    for f in fs:
        path = os.path.join(root,f)
        try:
            digest = sha256sum(path)
            files.append({"path": path, "sha256": digest})
        except Exception as e:
            files.append({"path": path, "error": str(e)})

# Trova duplicati
seen = {}
duplicates = []
for f in files:
    if "sha256" in f:
        if f["sha256"] in seen:
            duplicates.append([seen[f["sha256"]], f["path"]])
        else:
            seen[f["sha256"]] = f["path"]

report = {"files": files, "duplicates": duplicates}
os.makedirs("data", exist_ok=True)
with open("data/report.json","w") as out:
    json.dump(report,out,indent=2)

print("✅ Report generato in data/report.json")
