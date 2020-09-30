resource "google_compute_forwarding_rule" "gcp_forwardking_rule" {
  name        = "${var.name}"
  region      = "${var.region}"
  ip_protocol = "${var.ip_protocol}"
  port_range  = "${var.port_range}"
  ip_address  = "${google_compute_address.vpn_static_ip.address}"
  target      = "${google_compute_vpn_gateway.target_gateway.self_link}"
}