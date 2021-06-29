variable access_policy_name {
  type = string
  description = "Name of the access policy retrieved from the google_access_context_policy_manager resource"
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
  validation {}
}
