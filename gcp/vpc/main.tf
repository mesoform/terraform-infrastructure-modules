resource "google_compute_network" "gcp_vpc" {
  name       = "${var.name}"
  ipv4_range = "10.120.0.0/16"
}