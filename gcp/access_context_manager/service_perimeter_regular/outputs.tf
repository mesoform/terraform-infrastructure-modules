output "var_ingress_policies_file_path" {
  value = var.ingress_file_path
}

output "var_egress_policies_file_path" {
  value = var.egress_file_path
}
output "locals_ingress_policies_file_path" {
  value = local.ingress_file
}

output "locals_egress_policies_file_path" {
  value = local.egress_file
}

output "locals_ingress_policies" {
  value = local.ingress_policies
}

output "locals_egress_policies" {
  value = local.egress_policies
}

output locals_vpc_accessible_services {
  value = local.vpc_accessible_services
}

output locals_restricted_services {
  value = local.restricted_services
}
