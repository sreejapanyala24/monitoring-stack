#!/bin/bash
set -e

# Install Alertmanager
# Create alertmanager user if it doesn't exist
if ! id alertmanager >/dev/null 2>&1; then
  useradd --no-create-home --shell /bin/false alertmanager
fi

mkdir -p /etc/alertmanager
mkdir -p /var/lib/alertmanager
cd /tmp

# Download Alertmanager
wget https://github.com/prometheus/alertmanager/releases/download/v0.27.0/alertmanager-0.27.0.linux-amd64.tar.gz
tar -xvf alertmanager-0.27.0.linux-amd64.tar.gz

# Move binaries
cp alertmanager-0.27.0.linux-amd64/alertmanager /usr/local/bin/
cp alertmanager-0.27.0.linux-amd64/amtool /usr/local/bin/

# Fix permissions
chmod 755 /usr/local/bin/alertmanager
chmod 755 /usr/local/bin/amtool


cp /tmp/alertmanager.yml /etc/alertmanager/alertmanager.yml

# Give ownership
chown -R alertmanager:alertmanager /etc/alertmanager
chown -R alertmanager:alertmanager /var/lib/alertmanager

# Create systemd service
cat > /etc/systemd/system/alertmanager.service << 'SVCEOF'
[Unit]
Description=Alertmanager Service
Wants=network-online.target
After=network-online.target

[Service]
User=alertmanager
Group=alertmanager
Type=simple
ExecStart=/usr/local/bin/alertmanager \
  --config.file=/etc/alertmanager/alertmanager.yml \
  --storage.path=/var/lib/alertmanager/ \
  --web.listen-address=":9093"

Restart=always

[Install]
WantedBy=multi-user.target
SVCEOF

# Enable and start service
systemctl daemon-reload
systemctl enable alertmanager
systemctl start alertmanager
