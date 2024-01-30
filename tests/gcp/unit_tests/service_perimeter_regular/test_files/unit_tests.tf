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
data external test_vpc_accessible_services {
  query = local.vpc_accessible_services == null ? {service = "empty"} : {for service in local.vpc_accessible_services: service => service}
  program = ["python", "${path.module}/python/test_vpc_accessible_services_${var.test_type}.py"]
}

output test_vpc_accessible_services {
  value = data.external.test_vpc_accessible_services.result
}

//VPC Accessible Services - Enable Restriction
data external test_vpc_accessible_services_enabled {
  query = {enabled = local.vpc_accessible_services_enabled}
  program = ["python", "${path.module}/python/test_vpc_accessible_services_enabled_${var.test_type}.py"]
}

output test_vpc_accessible_services_enabled {
  value = data.external.test_vpc_accessible_services_enabled.result
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
data external test_egress_policy {
  query = {"identity-type" = try(local.egress_policies[0]["egressFrom"]["identityType"], ""),
            "serviceName" = try(local.egress_policies[0]["egressTo"]["operations"][0]["serviceName"], ""),
            "method" = try(local.egress_policies[0]["egressTo"]["operations"][0]["methodSelectors"][0]["method"], ""),
            "resource" = try(local.egress_policies[0]["egressTo"]["resources"][0], "")}
  program = ["python", "${path.module}/python/test_egress_policy.py"]
}

output test_egress_policy {
  value = data.external.test_egress_policy.result
}

// Empty Ingress Policy
data external test_ingress_policy_non_existent{
  query = local.ingress_file == null ? {} : {exists = true}
  program = ["python", "${path.module}/python/test_ingress_policy_empty.py"]
}

output test_ingress_policy_non_existent_file{
  value = data.external.test_ingress_policy_non_existent.result
}


// Empty Egress Policy
data external test_egress_policy_non_existent{
  query = local.egress_file == null ? {} : {exists = true}
  program = ["python", "${path.module}/python/test_egress_policy_empty.py"]
}

output test_egress_policy_non_existent_file{
  value = data.external.test_egress_policy_non_existent.result
}

