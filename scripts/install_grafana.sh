#!/bin/bash
set -e

apt-get install -y adduser libfontconfig1

cd /tmp
wget https://dl.grafana.com/oss/release/grafana_10.2.3_amd64.deb
apt-get install -y ./grafana_10.2.3_amd64.deb

systemctl daemon-reload
systemctl enable grafana-server
systemctl start grafana-server
