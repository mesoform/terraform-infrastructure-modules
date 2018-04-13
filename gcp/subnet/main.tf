resource "google_compute_subnetwork" "self_public_google_access" {
  count = "${length(var.external_ip_cidr_range) > 0 ? length(var.external_ip_cidr_range) : 0}"

  name          = "${var.name}"
  ip_cidr_range = "${var.external_ip_cidr_range[count.index]}"
  network       = "${var.vpc}"
}

##########################################################################################
# The VMs in this subnet can access Google services without assigned external IP addresses
##########################################################################################
resource "google_compute_subnetwork" "self_private_public_access" {
  count = "${length(var.underlay_ip_cidr_range) > 0 ? length(var.underlay_ip_cidr_range) : 0}"

  name          = "${var.name}"
  ip_cidr_range = "${var.underlay_ip_cidr_range[count.index]}"
  network       = "${var.vpc}"
  private_ip_google_access = true
}