module "allow_ingress_icmp_tags" {
  source = "../../gcp/firewall_rule_ingress"
  directive = "allow"
  protocol = "icmp"
  type = "tags"
  network = "gcp-vpc-underlay"
  ports = ["53", "25"]
  target_tags = ["dns-port", "smtp-port"]
  project = "ace-falcon-191115"
  source_ranges = ["0.0.0.0/0"]
}