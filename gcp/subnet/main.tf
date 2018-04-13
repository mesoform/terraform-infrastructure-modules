resource "google_compute_subnetwork" "self_public_gcp_api_ccess" {
  count = "${length(var.public_subnets) > 0 ? length(var.public_subnets) : 0}"

  name          = "${var.name}"
  ip_cidr_range = "${var.public_subnets[count.index]}"
  network       = "${var.vpc}"
}

##########################################################################################
# The VMs in this subnet can access Google services without assigned external IP addresses
##########################################################################################
resource "google_compute_subnetwork" "self_private_gcp_api_access" {
  count = "${length(var.private_subnets) > 0 ? length(var.private_subnets) : 0}"

  name          = "${var.name}"
  ip_cidr_range = "${var.private_subnets[count.index]}"
  network       = "${var.vpc}"
  private_ip_google_access = true
}