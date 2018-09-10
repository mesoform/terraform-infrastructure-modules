provider "google" {
  region      = "europe-west2"
  project = "gb-me-services"

}

module "allow_ingress_fw_rule_icmp" {
  source = "../../gcp/firewall_rule_ingress"
  directive = "allow"
  protocol = "icmp"
  type = "tags"
  network = "gcp-fw-rule-test"
  target_tags = ["allow-icmp"]
  source_ranges = ["0.0.0.0/0"]
}

module "allow_ingress_fw_rule_tcp" {
  source = "../../gcp/firewall_rule_ingress"
  directive = "allow"
  protocol = "tcp"
  ports = ["53", "25"]
  type = "tags"
  network = "gcp-fw-rule-test"
  target_tags = ["dns-server", "smtp-server"]
  source_tags = ["dns-client", "smtp-client"]
}

module "deny_ingress_fw_rule_ips" {
  source = "../../gcp/firewall_rule_ingress"
  directive = "deny"
  protocol = "tcp"
  ports = ["53", "25"]
  type = "ips"
  network = "gcp-fw-rule-test"
  source_ranges = ["10.0.2.0/24"]
  destination_ranges = ["10.0.1.0/24"]
}