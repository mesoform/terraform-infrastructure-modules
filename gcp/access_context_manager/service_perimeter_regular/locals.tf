locals {
  ingress_file      = fileexists(var.ingress_file_path) ? file(var.ingress_file_path) : null
  ingress           = try(yamldecode(local.ingress_file), {})
  ingress_status    = lookup(local.ingress, "status", {})
  ingress_policies  = lookup(local.ingress_status, "ingressPolicies", [])
  ingress_resources = lookup(local.ingress_status, "resources", {})

  egress_file      = fileexists(var.egress_file_path) ? file(var.egress_file_path) : null
  egress           = try(yamldecode(local.egress_file), {})
  egress_status    = lookup(local.egress, "status", {})
  egress_policies  = lookup(local.egress_status, "egressPolicies", [])
  egress_resources = lookup(local.egress_status, "resources", {})

  vpc_accessible_services = var.vpc_accessible_services == null ? ["RESTRICTED-SERVICES"] : var.vpc_accessible_services
}