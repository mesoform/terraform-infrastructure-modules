// Default VPC Accessible Service Values
module default_tests{
  source = "./test_files"
  access_policy_name = "name"
  name = "name"
}
output test_default_vpc_allowed_services {
  value = module.default_tests.test_vpc_accessible_services
}

output test_default_vpc_enabled_services {
  value = module.default_tests.test_vpc_accessible_services_enabled
}
output test_default_restricted_services {
  value = module.default_tests.test_restricted_services
}

//Specified VPC accessible Services
module specified_tests{
  source = "./test_files"
  access_policy_name = "name"
  name = "name"
  test_type = "specified"
  restricted_services = ["storage.googleapis.com", "compute.googleapis.com"]
  vpc_accessible_services = ["storage.googleapis.com", "compute.googleapis.com"]
}
output test_specified_vpc_allowed_services {
  value = module.specified_tests.test_vpc_accessible_services
}

output test_specified_vpc_enabled_services {
  value = module.default_tests.test_vpc_accessible_services_enabled
}
output test_entered_restricted_services {
  value = module.specified_tests.test_restricted_services
}

// VPC accessible Services - All-Services
module all_services_tests{
  source = "./test_files"
  access_policy_name = "name"
  name = "name"
  test_type = "all_services"
  restricted_services = ["All-SERVICES"]
  vpc_accessible_services = ["ALL-SERVICES"]
}
output test_all_services_vpc_allowed_services {
  value = module.specified_tests.test_vpc_accessible_services
}

output test_all_services_vpc_enabled_services {
  value = module.default_tests.test_vpc_accessible_services_enabled
}
output test_all_services_restricted_services {
  value = module.specified_tests.test_restricted_services
}


// VPC accessible services - no services

module no_services_specified_tests{
  source = "./test_files"
  access_policy_name = "name"
  name = "name"
  test_type = "no_services"
  restricted_services = []
  vpc_accessible_services = []
}
output test_no_service_vpc_allowed_services {
  value = module.specified_tests.test_vpc_accessible_services
}

output test_no_service_vpc_enabled_services {
  value = module.default_tests.test_vpc_accessible_services_enabled
}
output test_no_service_restricted_services {
  value = module.specified_tests.test_restricted_services
}


//Ingress and Egress
module ingress_egress_test{
  source = "./test_files"
  ingress_file_path = "./test_files/ingress_policies.yml"
  egress_file_path = "./test_files/egress_policies.yml"
  access_policy_name = "name"
  name = "name"
}

output test_ingress_policies {
  value = module.ingress_egress_test.test_ingress_policy
}

output test_egress_policies {
  value = module.ingress_egress_test.test_egress_policy_non_existent_file
}
