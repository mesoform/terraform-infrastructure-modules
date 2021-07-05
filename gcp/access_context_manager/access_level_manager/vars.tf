variable access_policy_name {
  type = string
  description = "ID of the access policy retrieved from the google_access_context_policy_manager resource"
}

variable access_level_name {
  type = string
  description = "Short name for resource name"
}

variable description {
  type = string
  default = null
}

variable allowed_ip_subnetworks {
  type = list(string)
  description = "List of CIDR block IP subnetworks. May be IPv4 or IPv6"
  default = []
}

variable allowed_members {
  type = list(string)
  description = "List of allowed members (users or services accounts, not groups)"
  default = []
}

variable allowed_regions {
  type = list(string)
  description = "List of allowed regions. The request must originate from one of the provided countries/regions"
  default = []
}
