variable test_type {
  description = "Excecute test using null, default, or entered values"
  type = string
  validation {
    condition = contains(["default", "specified", "all_services", "no_services"], var.test_type)
    error_message = "Not a valid test type."
  }
  default = "default"
}

//VPC Accessible Services - Allowed Services
data external test_vpc_allowed_services{
  query = local.vpc_allowed_services == null ? {service = "empty"} : {for service in local.vpc_allowed_services: service => service}
  program = ["python", "${path.module}/python/test_vpc_allowed_services_${var.test_type}.py"]
}

output test_vpc_allowed_services {
  value = data.external.test_vpc_allowed_services.result
}

//VPC Accessible Services - Enable Restriction
data external test_vpc_enable_restriction{
  query = {enabled = local.vpc_enable_restriction}
  program = ["python", "${path.module}/python/test_vpc_enable_restriction_${var.test_type}.py"]
}

output test_vpc_enable_restriction{
  value = data.external.test_vpc_enable_restriction.result
}

// Restricted Services
data external test_restricted_services {
  query = local.vpc_accessible_services == null ? {service = "empty"} : {for service in local.restricted_services: service => service}
  program = ["python", "${path.module}/python/test_restricted_services_${var.test_type}.py"]
}

output "test_restricted_services" {
  value = data.external.test_restricted_services.result
}


// Ingress Policy
data external test_ingress_policy {
  query = {"identity-type" = try(local.ingress_policies[0]["ingressFrom"]["identityType"], ""),
            "source-one" = try(local.ingress_policies[0]["ingressFrom"]["sources"][0]["accessLevel"], "")}
  program = ["python", "${path.module}/python/test_ingress_policy.py"]
}

output test_ingress_policy {
  value = data.external.test_ingress_policy.result
}

// Egress Policy
data external test_egress_policy_non_existent{
  query = local.egress_file == null ? {} : {exists = true}
  program = ["python", "${path.module}/python/test_egress_policy.py"]
}

output test_egress_policy_non_existent_file{
  value = data.external.test_egress_policy_non_existent.result
}

