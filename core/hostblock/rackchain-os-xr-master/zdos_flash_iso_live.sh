#!/bin/bash
echo "💿 Generazione ISO LIVE RACKCHAIN OS XR∞"
mkdir -p ~/rackchain_iso_live/modules
cp ~/rackchain_os_fused/modules/*.py ~/rackchain_iso_live/modules/
echo "LABEL rackchain_os" > ~/rackchain_iso_live/boot.cfg
echo "✅ ISO LIVE simulata in ~/rackchain_iso_live"
