[![Deploy with Vercel](https://vercel.com/button)](https://vercel.com/import/project?template=https://github.com/HighKali/ecoblock-dashboard)

### 📄 README.md — versione migliorata 

```markdown
# 🌐 EcoBlock Dashboard

**Dashboard modulare, etica e laser-ready per il progetto EcoBlock.**  
Visualizza, verifica, mina e sincronizza in tempo reale con stile e trasparenza.

---

## 🚀 Moduli inclusi

| Modulo        | Descrizione                                                                 |
|---------------|------------------------------------------------------------------------------|
| 🛰️ **GeoBlock**   | Localizzazione IP e generazione di wallet entropici                      |
| ⛏️ **EcoMiner**   | Monitoraggio mining pool, hashrate e stato dei nodi                      |
| ✅ **EcoVerify**  | Verifica automatica dei moduli attivi e della salute del sistema         |
| 🔐 **EcoEntropy** | Generazione di entropia per wallet e chiavi                              |
| 🧹 **EcoPurge**   | Pulizia intelligente di file temporanei e non rilevanti                  |
| 🗺️ **EcoMap**     | Mappa SVG laser interattiva con animazioni e coordinate dinamiche        |
| 🔄 **EcoSync**    | Commit, push e sincronizzazione automatica su GitHub                     |

---

## 🎨 Design

- Tema **Dark Laser** ispirato ai migliori dashboard crypto
- Layout **responsive** per mobile, tablet e desktop
- **Animazioni SVG** per mappe, icone e notifiche
- **Notifiche visive** in tempo reale con `eco_ui_notify.js`

---

## ⚙️ Deploy su Vercel

Configurazione pronta per il deploy statico su [Vercel](https://vercel.com):

```json
{
  "version": 2,
  "builds": [{ "src": "index.html", "use": "@vercel/static" }],
  "routes": [{ "src": "/", "dest": "/index.html" }]
}
```

---

## 📦 Setup rapido

```bash
git clone https://github.com/HighKali/ecoblock-dashboard.git
cd ecoblock-dashboard
bash eco_publish.sh
```

---

## 👥 Autori

| Nome     | Ruolo                      | Impatto                        |
|----------|----------------------------|--------------------------------|
| **Roberto**  | Architetto, UI, orchestrazione | Visione etica, automazione, laser-style |
| **HighKali** | RPC, CLI, zDOS             | FastAPI, mining, export universale     |

> ✨ Ogni modulo è una firma. Ogni commit è un atto creativo. Ogni contributo è celebrato.

---

## 📡 Stato del progetto

- ✅ Pronto per deploy su Vercel
- ✅ Compatibile con Termux, Linux, VPS
- ✅ Ottimizzato per collaborazioni globali
- ✅ Modulare, etico, documentato

---

## 🤝 Contribuire

Vuoi contribuire? Forka il progetto, crea una branch, proponi una PR.  
Ogni contributo è benvenuto e sarà celebrato nel file `CONTRIBUTORS.md`.

---

## 🛡️ Licenza

Questo progetto è distribuito sotto licenza **MIT**.  
Libero, trasparente, riutilizzabile. Per tutti.

--
