[![Deploy with Vercel](https://vercel.com/button)](https://vercel.com/import/project?template=https://github.com/HighKali/ecoblock-dashboard)


# 🌐 EcoBlock Dashboard

Dashboard modulare, etica e laser-ready per il progetto EcoBlock.  
Visualizza, verifica, mina e sincronizza in tempo reale.

## 🚀 Moduli inclusi

- `GeoBlock` – Localizzazione IP e wallet entropico
- `EcoMiner` – Stato mining pool e hashrate
- `EcoVerify` – Verifica moduli attivi
- `EcoEntropy` – Generazione entropica
- `EcoPurge` – Pulizia file non rilevanti
- `EcoMap` – Mappa SVG laser interattiva
- `EcoSync` – Commit e push automatico su GitHub

## 🎨 Design

- Tema dark laser
- Layout responsive
- SVG mappe e icone animate

## ⚙️ Deploy

Configurato per Vercel con `vercel.json`:

```json
{
  "version": 2,
  "builds": [{ "src": "index.html", "use": "@vercel/static" }],
  "routes": [{ "src": "/", "dest": "/index.html" }]
}

## 📦 SETUP RAPIDO

git clone https://github.com/HighKali/ecoblock-dashboard.git
cd ecoblock-dashboard
bash eco_publish.sh







