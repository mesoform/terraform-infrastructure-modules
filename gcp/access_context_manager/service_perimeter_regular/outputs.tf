output "locals_ingress_policies" {
  value = local.ingress_policies
}

output "locals_egress_policies" {
  value = local.ingress_policies
}

output locals_vpc_accessible_services {
  value = local.vpc_accessible_services
}

output locals_restricted_services {
  value = local.restricted_services
}
