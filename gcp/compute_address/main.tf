resource "google_compute_address" "gcp_static_address" {
  name   = "${var.name}"
  region = "${var.region}"
}