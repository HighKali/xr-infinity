#!/bin/bash
echo "🌌 Inizio unificazione e allegamento dei moduli XR∞..."

mkdir -p ~/xr∞_anello
cd ~/xr∞_anello

# 🔍 Elenco moduli orbitanti
modules=(
  "bionc_kstars_bridge.py"
  "pulsar_dashboard_web.py"
  "eco_log.py"
  "xr∞_pulse.py"
  "dsn_monitor.py"
  "generate_badge.sh"
  "launch_dashboard.sh"
  "pulsar_sync.sh"
  "xr∞_anello.sh"
  "xr∞_genesis.sh"
  "xr∞_publish.sh"
  "pulsar_badge.svg"
  "eco_events.log"
)

# 🔁 Ricrea moduli mancanti
for module in "${modules[@]}"; do
  if [ ! -f "$module" ]; then
    echo "🛠️ Ricreazione modulo mancante: $module"
    case "$module" in
      "eco_log.py") echo 'from datetime import datetime; def log_event(e): open("eco_events.log","a").write(f"{datetime.now().isoformat()} — {e}\n")' > "$module" ;;
      "xr∞_pulse.py") echo 'import time; print("💓 XR∞ Pulse: Costellazione attiva"); time.sleep(60)' > "$module" ;;
      "dsn_monitor.py") echo 'import webbrowser; webbrowser.open("https://birdeye.so/token/0xfc90516a1f736FaC557e09D8853dB80dA192c296?chain=polygon")' > "$module" ;;
      "generate_badge.sh") echo 'echo "<svg xmlns=\"http://www.w3.org/2000/svg\" width=\"200\" height=\"100\"><text x=\"10\" y=\"50\" fill=\"lime\">XR∞ VALIDATOR 👽</text></svg>" > pulsar_badge.svg' > "$module" ;;
      "launch_dashboard.sh") echo 'python3 pulsar_dashboard_web.py' > "$module" ;;
      "pulsar_sync.sh") echo 'for m in *.py *.sh; do echo "👽 Lancio $m"; [[ $m == *.py ]] && python3 "$m" || bash "$m"; done' > "$module" ;;
      "xr∞_anello.sh") echo 'python3 eco_log.py; python3 xr∞_pulse.py; bash pulsar_sync.sh' > "$module" ;;
      "xr∞_genesis.sh") echo 'echo "🌌 Rigenerazione completa XR∞"; bash xr∞_anello.sh' > "$module" ;;
      "xr∞_publish.sh") echo 'git init; git add .; git commit -m "🌠 Finalizzazione XR∞"; read -p "URL GitHub: " url; git remote add origin "$url"; git push -u origin main' > "$module" ;;
      "pulsar_badge.svg") echo '<svg xmlns="http://www.w3.org/2000/svg" width="200" height="100"><text x="10" y="50" fill="lime">XR∞ VALIDATOR 👽</text></svg>' > "$module" ;;
      "eco_events.log") touch "$module" ;;
    esac
  else
    echo "✅ Modulo già presente: $module"
  fi
done

# 🔐 Permessi esecuzione
chmod +x *.sh

echo "🚀 Tutti i moduli XR∞ sono stati unificati e allegati."
