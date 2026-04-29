#!/bin/bash
set -e
# Install Node Exporter
cd /tmp
wget https://github.com/prometheus/node_exporter/releases/download/v1.7.0/node_exporter-1.7.0.linux-amd64.tar.gz
tar -xvf node_exporter-1.7.0.linux-amd64.tar.gz
cp node_exporter-1.7.0.linux-amd64/node_exporter /usr/local/bin/
#create node exporter service file
cat > /etc/systemd/system/node_exporter.service << 'SVCEOF'
[Unit]
Description=Node Exporter
After=network.target
[Service]
User=root
ExecStart=/usr/local/bin/node_exporter
Restart=always
[Install]
WantedBy=multi-user.target
SVCEOF
#Enable services
systemctl daemon-reload
systemctl enable node_exporter
systemctl start node_exporter