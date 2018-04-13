resource "google_compute_subnetwork" "self_public_google_access" {
  count = "${var.private_ip_google_access == false ? length(var.ip_cidr_range) : 0}"

  name          = "${var.name}"
  ip_cidr_range = "${var.ip_cidr_range[count.index]}"
  network       = "${var.vpc}"
}

##########################################################################################
# The VMs in this subnet can access Google services without assigned external IP addresses
##########################################################################################
resource "google_compute_subnetwork" "self_private_public_access" {
  count = "${var.private_ip_google_access == true ? length(var.ip_cidr_range) : 0}"

  name          = "${var.name}"
  ip_cidr_range = "${var.ip_cidr_range[count.index]}"
  network       = "${var.vpc}"
  private_ip_google_access = true
}