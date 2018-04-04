resource "google_compute_subnetwork" "self_public_google_access" {
  count = "${length(var.public_api_access_subnets) > 0 ? length(var.public_api_access_subnets) : 0}"

  name          = "${element(var.name, count.index)}"
  ip_cidr_range = "${var.ip_cidr_range[count.index]}"
  network       = "${var.vpc}"
}

##########################################################################################
# The VMs in this subnet can access Google services without assigned external IP addresses
##########################################################################################
resource "google_compute_subnetwork" "self_private_public_access" {
  count = "${length(var.private_api_access_subnets) > 0 ? length(var.private_api_access_subnets) : 0}"

  name          = "${element(var.name, count.index)}"
  ip_cidr_range = "${var.ip_cidr_range[count.index]}"
  network       = "${var.vpc}"
  private_ip_google_access = true
}