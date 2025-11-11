#!/bin/bash
echo "🐳 Deploy RACKCHAIN OS XR∞ in Docker"
mkdir -p ~/rackchain_docker/modules
cp ~/rackchain_os_fused/modules/*.py ~/rackchain_docker/modules/
cat > ~/rackchain_docker/Dockerfile <<EOF
FROM python:3.12
WORKDIR /app
COPY modules/ .
RUN pip install flask web3 qrcode
CMD ["python3", "rackchain_terminator.py"]
EOF
cd ~/rackchain_docker
docker build -t rackchain_os .
docker run -d -p 8545:8545 --name rackchain_node rackchain_os
echo "✅ Nodo Docker attivo su :8545"
