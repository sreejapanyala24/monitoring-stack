#!/bin/bash
set -e
apt update -y
apt install -y wget curl
mkdir -p /opt/scripts

cat << 'EOF' > /opt/scripts/install_prometheus.sh
${install_prometheus}
EOF

cat << 'EOF' > /opt/scripts/install_node_exporter.sh
${install_node_exporter}
EOF

cat << 'EOF' > /opt/scripts/install_grafana.sh
${install_grafana}
EOF

chmod +x /opt/scripts/*.sh

bash /opt/scripts/install_prometheus.sh
bash /opt/scripts/install_node_exporter.sh
bash /opt/scripts/install_grafana.sh

echo "All monitoring services installed successfully!"