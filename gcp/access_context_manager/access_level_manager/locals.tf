locals {
  allowed_ip_subnetworks = var.allowed_ip_subnetworks == null ? ["DENY-ALL"] : var.allowed_ip_subnetworks
  allowed_members = var.allowed_members == null ? ["DENY-ALL"] : var.allowed_members
  allowed_regions = var.allowed_regions == null ? ["DENY-ALL"] : var.allowed_regions
}
