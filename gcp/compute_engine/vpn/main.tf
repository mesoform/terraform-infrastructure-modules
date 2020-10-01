# wraps up other primative modules
module "gcp_vpc" {
  source      = "./vpc"
  name        = "${var.vpc_name}"
}

module "gcp_vpn_gateway" {
  source      = "./vpn_gateway"
  name        = "${var.vpn_gateway_name}"
  region      = "${var.region}"
}

module "gcp_compute_address" {
  source      = "./compute_address"
  name        = "${var.compute_address_name}"
  region      = "${var.region}"
}

module "gcp_forwarding_rule" {
  source      = "./forwarding_rule"
  name        = "${var.gcp_fr_name_prefix}-fr-esp"
  region      = "${var.region}"
  ip_protocol = "ESP"
}

module "gcp_forwarding_rule" {
  source      = "./forwarding_rule"
  name        = "${var.gcp_fr_name_prefix}-fr-udp500"
  region      = "${var.region}"
  ip_protocol = "UDP"
  port_range  = "500"
}

module "gcp_forwarding_rule" {
  source      = "./forwarding_rule"
  name        = "${var.gcp_fr_name_prefix}-fr-udp4500"
  region      = "${var.region}"
  ip_protocol = "UDP"
  port_range  = "4500"
}

module "gcp_vpn_tunnel" {
  source      = "./vpn_tunnel"
  name        = "${var.vpn_tunnel_name_prefix}-tunnel-1"
  region      = "${var.region}"
  peer_ip     = "${var.vpn_peer_ip}"
  shared_secret = "${var.tunnel1_secret}"

  target_vpn_gateway = "${google_compute_vpn_gateway.gcp_vpn_gateway.self_link}"

  depends_on = [
    "google_compute_forwarding_rule.fr_esp",
    "google_compute_forwarding_rule.fr_udp500",
    "google_compute_forwarding_rule.fr_udp4500",
  ]
}

module "gcp_vpn_tunnel" {
  source      = "./vpn_tunnel"
  name        = "${var.vpn_tunnel_name_prefix}-tunnel-2"
  region      = "${var.region}"
  peer_ip     = "${var.vpn_peer_ip}"
  shared_secret = "${var.tunnel2_secret}"

  target_vpn_gateway = "${google_compute_vpn_gateway.gcp_vpn_gateway.self_link}"

  depends_on = [
    "google_compute_forwarding_rule.fr_esp",
    "google_compute_forwarding_rule.fr_udp500",
    "google_compute_forwarding_rule.fr_udp4500",
  ]
}
