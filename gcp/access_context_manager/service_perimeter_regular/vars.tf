variable access_policy_name {
  type = string
  description = "ID of the access policy retrieved from the google_access_context_policy_manager resource"
}

variable vpc_accessible_services {
  type = list(string)
  default = [
    "RESTRICTED-SERVICES"
  ]
  description = "Services that can be accessed from within the perimeter"
}

variable restricted_services {
  type = list(string)
  description = "Services to restrict on perimeter"
  default = null
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
  default = false
}

variable access_levels {
  type = list(string)
  default = []
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

variable resources {
  type = list(string)
  description = "List of project IDs to include within the perimeter"
  default = []
}
