resource "google_compute_vpn_tunnel" "gcp_vpn_tunnel" {
  name          = "${var.name}"
  region        = "${var.region}"
  peer_ip       = "${var.peer_ip}"
  shared_secret = "${var.shared_secret}"

  target_vpn_gateway = "${var.target_vpn_gateway}"

  depends_on = [
    "google_compute_forwarding_rule.fr_esp",
    "google_compute_forwarding_rule.fr_udp500",
    "google_compute_forwarding_rule.fr_udp4500",
  ]
}