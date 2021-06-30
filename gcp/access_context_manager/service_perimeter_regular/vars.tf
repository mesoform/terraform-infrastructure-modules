variable access_policy_name {
  type = string
  description = "Name of the access policy retrieved from the google_access_context_policy_manager which takes the format of the policy ID"
}

variable vpc_accessible_services {
  type = list(string)
  default = [
    "RESTRICTED-SERVICES"
  ]
}

variable restricted_services {
  type = list(string)
  description = "Services to restrict on perimeter"
  default = ["*"]
}

variable name {
  type = string
  description = "Short name for resource name"
}

variable description {
  type = string
  default = null
}

variable dry_run_mode {
  type = bool
  description = "Whether to use explicit dry run spec"
  default = null
}

variable access_levels {
  type = list(string)
  default = []
}

variable domain {
  type = string
  default = null
}

variable ingress_file_path {
  type = string
  description = "Path to the YAML file containing the ingress configuration"
  default = "./ingress_policies.yml"
}

variable egress_file_path {
  type = string
  description = "Path to the YAML file containing the egress configuration"
  default = "./egress_policies.yml"
}