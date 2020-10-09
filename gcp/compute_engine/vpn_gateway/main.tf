resource "google_compute_vpn_gateway" "gcp_target_gateway" {
  name    = "${var.name}"
  network = "${google_compute_network.network1.self_link}"
  region  = "${var.region}"
}