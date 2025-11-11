#!/usr/bin/env bash
set -e
if command -v boinc >/dev/null 2>&1; then
  nohup boinc --daemon >/dev/null 2>&1 &
  sleep 3
  boinccmd --get_state || true
else
  proot-distro login debian -- bash -lc "apt update && apt install -y boinc-client && nohup boinc --daemon >/dev/null 2>&1 & sleep 3 && boinccmd --get_state || true"
fi
