resource "aws_instance" "monitoring" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = var.subnet_id
  vpc_security_group_ids = [var.sg_id]
  key_name               = var.key_name


  user_data = (templatefile("${path.module}/user_data.sh", {
    install_prometheus    = file("${path.module}/../../../scripts/install_prometheus.sh")
    install_node_exporter = file("${path.module}/../../../scripts/install_node_exporter.sh")
    install_grafana       = file("${path.module}/../../../scripts/install_grafana.sh")
    install_alertmanager  = file("${path.module}/../../../scripts/install_alertmanager.sh")
    alert_rules           = file("${path.module}/../../../prometheus/alert.rules.yml")
    alertmanager_config   = file("${path.module}/../../../alertmanager/alertmanager.yml")
  }))


  tags = {
    Name = "monitoring-instance"
  }
}
