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

cat << 'EOF' > /opt/scripts/install_alertmanager.sh
${install_alertmanager}
EOF

cat << 'EOF' > /tmp/alert.rules.yml
${alert_rules}
EOF
cat << 'EOF' > /tmp/alertmanager.yml
${alertmanager_config}
EOF

chmod +x /opt/scripts/*.sh

bash /opt/scripts/install_prometheus.sh
bash /opt/scripts/install_node_exporter.sh
bash /opt/scripts/install_grafana.sh
bash /opt/scripts/install_alertmanager.sh

echo "All monitoring services installed successfully!"