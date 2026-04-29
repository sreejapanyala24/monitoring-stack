#!/bin/bash
set -e
# Install Prometheus
# Create prometheus user if it doesn't exist
if ! id prometheus >/dev/null 2>&1; then
  useradd --no-create-home --shell /bin/false prometheus
fi
mkdir -p /etc/prometheus
mkdir -p /var/lib/prometheus
cd /tmp
wget https://github.com/prometheus/prometheus/releases/download/v2.45.0/prometheus-2.45.0.linux-amd64.tar.gz
tar -xvf prometheus-2.45.0.linux-amd64.tar.gz
cp prometheus-2.45.0.linux-amd64/prometheus /usr/local/bin/
cp prometheus-2.45.0.linux-amd64/promtool /usr/local/bin/
cp -r prometheus-2.45.0.linux-amd64/consoles /etc/prometheus
cp -r prometheus-2.45.0.linux-amd64/console_libraries /etc/prometheus
#fix binary permissions
chmod 755 /usr/local/bin/prometheus
chmod 755 /usr/local/bin/promtool
#give prometheus ownership to config/data dirs
chown -R prometheus:prometheus /etc/prometheus
chown -R prometheus:prometheus /var/lib/prometheus
# Create Prometheus config file
cat > /etc/prometheus/prometheus.yml << 'CONFIGEOF'
global:
  scrape_interval: 5s
scrape_configs:
  - job_name: "prometheus"
    static_configs:
      - targets: ["localhost:9090"]
  - job_name: "node_exporter"
    static_configs:
      - targets: ["localhost:9100"]
rule_files:
  - "alert.rules.yml"

CONFIGEOF
#create prometheus service file
cat > /etc/systemd/system/prometheus.service << 'SVCEOF'
[Unit]
Description=Prometheus Monitoring
Wants=network-online.target
After=network-online.target
[Service]
User=prometheus
ExecStart=/usr/local/bin/prometheus --config.file=/etc/prometheus/prometheus.yml --storage.tsdb.path=/var/lib/prometheus/
Restart=always
[Install]
WantedBy=multi-user.target
SVCEOF
#Enable services
systemctl daemon-reload
systemctl enable prometheus
systemctl start prometheus