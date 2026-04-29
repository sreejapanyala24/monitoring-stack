**Monitoring Stack Runbook**
(Prometheus + Grafana + Alertmanager + Node Exporter)

**1. Overview**
   This runbook provides operational procedures for managing the self-hosted monitoring stack deployed on AWS EC2 using Terraform. The stack includes:
   Prometheus – metrics collection
   Node Exporter – system metrics
   Alertmanager – alert routing
   Grafana – dashboards and visualization
   All components run on Linux EC2 instances provisioned via Terraform.

**2. Accessing the Monitoring EC2 Instance**
   SSH into the instance
   ssh -i <your-key.pem> ubuntu@<EC2-PUBLIC-IP>

Check system resources
top
df -h
free -m

**3. Prometheus Operations**
   Service Management
   Check status
   sudo systemctl status prometheus
   Start / Stop / Restart
   sudo systemctl start prometheus
   sudo systemctl stop prometheus
   sudo systemctl restart prometheus
   View logs
   sudo journalctl -u prometheus -f
   Configuration
   Configuration files:
   /etc/prometheus/prometheus.yml
   /etc/prometheus/alert.rules.yml
   Validate Configuration
   promtool check config /etc/prometheus/prometheus.yml
   promtool check rules /etc/prometheus/alert.rules.yml
   Web UI
   http://<EC2-IP>:9090

**4. Alertmanager Operations**
   Service Management
   Check status
   sudo systemctl status alertmanager

Restart service
sudo systemctl restart alertmanager

View logs
sudo journalctl -u alertmanager -f
Configuration
Config file: /etc/alertmanager/alertmanager.yml
Web UI
http://<EC2-IP>:9093

**5. Node Exporter Operations**
   Service Management
   Check status
   sudo systemctl status node_exporter

Start / Stop / Restart
sudo systemctl restart node_exporter

Verify Metrics
curl http://localhost:9100/metrics

**6. Grafana Operations**
   Service Management
   Check status
   sudo systemctl status grafana-server

Restart service
sudo systemctl restart grafana-server

Web UI
URL: http://<EC2-IP>:3000
Default credentials:
Username: admin
Password: admin
Import Dashboard
Navigate to Grafana → Dashboards → Import
Upload: grafana/dashboards/nodeexporterfull.json
Select Prometheus as the datasource

**7. Triggering Alerts (for Testing)**
   Trigger High CPU Alert
   yes > /dev/null &
   Stop CPU Load
   killall yes
   Trigger Low Memory Alert
   stress --vm 1 --vm-bytes 700M --timeout 60s

**8. Troubleshooting**
   Prometheus Not Showing Alerts
   Check alert rules:
   promtool check rules /etc/prometheus/alert.rules.yml
   Ensure alerting block exists in prometheus.yml:
   alerting:  alertmanagers:    - static_configs:        - targets: ["localhost:9093"]
   Alertmanager Shows &#x201C;No Alert Groups Found&#x201D;
   Prometheus may not be forwarding alerts. Restart Prometheus:
   sudo systemctl restart prometheus
   Grafana Cannot Connect to Prometheus
   Check datasource URL is configured as: http://localhost:9090
   Verify security group allows ports 3000 (Grafana) and 9090 (Prometheus)
   Node Exporter Not Being Scraped
   Verify Prometheus target status:
   http://<EC2-IP>:9090/targets
   Ensure Node Exporter is running:
   sudo systemctl status node_exporter

**9. File Locations Summary**
   Component
   File Path
   Prometheus Config
   /etc/prometheus/prometheus.yml
   Alert Rules
   /etc/prometheus/alert.rules.yml
   Alertmanager Config
   /etc/alertmanager/alertmanager.yml
   Node Exporter
   /usr/local/bin/node_exporter
   Grafana Dashboards
   /var/lib/grafana/dashboards/


**10. Terraform Operations**
    Initialize
    terraform init
    Plan
    terraform plan
    Apply
    terraform apply
    Destroy
    terraform destroy
**11. Architecture Summary**
    The monitoring stack is deployed as follows:
    EC2 instance runs Prometheus, Alertmanager, Grafana, and Node Exporter
    Prometheus scrapes metrics from Node Exporter
    Alertmanager receives alerts triggered by Prometheus rules
    Grafana visualizes data from Prometheus via pre-built dashboards
