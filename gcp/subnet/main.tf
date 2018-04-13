resource "google_compute_subnetwork" "self_public_google_access" {
  count = "${length(var.ip_cidr_range) > 0 ? length(var.ip_cidr_range) : 0}"

  name          = "${element(var.name, count.index)}"
  ip_cidr_range = "${var.gcp_api_public_access_subnets[count.index]}"
  network       = "${var.vpc}"
}

##########################################################################################
# The VMs in this subnet can access Google services without assigned external IP addresses
##########################################################################################
resource "google_compute_subnetwork" "self_private_public_access" {
  count = "${length(var.ip_cidr_range) > 0 ? length(var.ip_cidr_range) : 0}"

  name          = "${element(var.name, count.index)}"
  ip_cidr_range = "${var.gcp_api_private_access_subnets[count.index]}"
  network       = "${var.vpc}"
  private_ip_google_access = true
}