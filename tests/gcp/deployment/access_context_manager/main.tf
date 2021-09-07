module regular_service_perimeter {
  source = "source-path"
  name = "test_perimeter"
  access_policy_name = "access-policy-name"
  ingress_file_path = "./ingressPolicies.yml"
  egress_file_path = "./egressPolicies.yml"
  resources = resources-list
}