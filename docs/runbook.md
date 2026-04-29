# RUNBOOK — Monitoring Stack (Prometheus + Grafana + Alertmanager + Node Exporter)

## 1. Overview

This runbook provides operational procedures for managing the self-hosted monitoring stack deployed on AWS EC2 using Terraform.

The stack includes:

- **Prometheus** – metrics collection
- **Node Exporter** – system metrics
- **Alertmanager** – alert routing
- **Grafana** – dashboards and visualization

All components run on Linux EC2 instances provisioned via Terraform.

---

## 2. Accessing the Monitoring EC2 Instance

### SSH into the instance

```bash
ssh -i <your-key.pem> ubuntu@<EC2-PUBLIC-IP>
```

### Check system resources

```bash
top
df -h
free -m
```

---

## 3. Prometheus Operations

### Check Prometheus service

```bash
sudo systemctl status prometheus
```

### Start / Stop / Restart

```bash
sudo systemctl start prometheus
sudo systemctl stop prometheus
sudo systemctl restart prometheus
```

### View Prometheus logs

```bash
sudo journalctl -u prometheus -f
```

### Prometheus config location

```
/etc/prometheus/prometheus.yml
/etc/prometheus/alert.rules.yml
```

### Validate Prometheus config

```bash
promtool check config /etc/prometheus/prometheus.yml
promtool check rules /etc/prometheus/alert.rules.yml
```

### Prometheus UI

```
http://<EC2-IP>:9090
```

---

## 4. Alertmanager Operations

### Check Alertmanager service

```bash
sudo systemctl status alertmanager
```

### Start / Stop / Restart

```bash
sudo systemctl restart alertmanager
```

### View logs

```bash
sudo journalctl -u alertmanager -f
```

### Config location

```
/etc/alertmanager/alertmanager.yml
```

### Alertmanager UI

```
http://<EC2-IP>:9093
```

---

## 5. Node Exporter Operations

### Check Node Exporter

```bash
sudo systemctl status node_exporter
```

### Start / Stop / Restart

```bash
sudo systemctl restart node_exporter
```

### Verify metrics endpoint

```bash
curl http://localhost:9100/metrics
```

---

## 6. Grafana Operations

### Check Grafana service

```bash
sudo systemctl status grafana-server
```

### Start / Stop / Restart

```bash
sudo systemctl restart grafana-server
```

### Grafana UI

```
http://<EC2-IP>:3000
```

### Default credentials

```
admin / admin
```

### Import dashboard

1. Grafana → Dashboards → Import
2. Upload: grafana/dashboards/nodeexporterfull.json
3. Select Prometheus datasource

---

## 7. Triggering Alerts (for testing)

### Trigger High CPU alert

```bash
yes > /dev/null &
```

### Stop CPU load

```bash
killall yes
```

### Trigger Low Memory alert (optional)

```bash
stress --vm 1 --vm-bytes 700M --timeout 60s
```

---

## 8. Troubleshooting

### Prometheus not showing alerts

Check alert rules:

```bash
promtool check rules /etc/prometheus/alert.rules.yml
```

Ensure alerting block exists in prometheus.yml:

```yaml
alerting:
  alertmanagers:
    - static_configs:
        - targets: ["localhost:9093"]
```

### Alertmanager shows "No alert groups found"

- Prometheus not forwarding alerts
- Restart Prometheus:

```bash
sudo systemctl restart prometheus
```

### Grafana cannot connect to Prometheus

- Check datasource URL:
  ```
  http://localhost:9090
  ```
- Check security group allows port 3000 (Grafana) and 9090 (Prometheus)

### Node Exporter not scraped

- Verify Prometheus target:
  ```
  http://<EC2-IP>:9090/targets
  ```
- Ensure Node Exporter is running:

```bash
sudo systemctl status node_exporter
```

---

## 9. File Locations Summary

| Component              | Path                                   |
|------------------------|----------------------------------------|
| Prometheus config      | /etc/prometheus/prometheus.yml          |
| Prometheus rules       | /etc/prometheus/alert.rules.yml         |
| Alertmanager config    | /etc/alertmanager/alertmanager.yml      |
| Node Exporter          | /usr/local/bin/node_exporter            |
| Grafana dashboards     | /var/lib/grafana/dashboards/            |

---

## 10. Terraform Operations

### Initialize

```bash
terraform init
```

### Plan

```bash
terraform plan
```

### Apply

```bash
terraform apply
```

### Destroy

```bash
terraform destroy
```

---

## 11. Architecture Summary

- EC2 instance runs:
    - Prometheus
    - Alertmanager
    - Grafana
    - Node Exporter

- Prometheus scrapes:
    - Node Exporter (system metrics)

- Alertmanager receives alerts from Prometheus

- Grafana visualizes Prometheus data