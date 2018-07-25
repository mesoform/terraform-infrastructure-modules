/* Required */
variable network {
  description = "The network this rule applies to."
  type        = "string"
  default     = "default"
}

/* One Required */
variable network_project {
  description = "Name of the project for the network. Useful for shared VPC. Default is var.project."
  type        = "string"
  default     = ""
}

variable project {
  description = "The project to deploy to, if not set the default provider project is used."
  type        = "string"
  default     = ""
}

/* deny block */
variable ports {
  description = "List of ports and/or ranges to deny."
  type        = "list"
  default     = []
}

variable protocol {
  description = "The name of the protocol to deny."
  type        = "string"
}

/* Optional */
variable name {
  description = "Firewall rule name."
  type        = "string"
  default     = ""
}

variable priority {
  description = "Rule priority. Lower numbers are given more precedence."
  type        = "string"
  default     = "1000"
}

variable source_ranges {
  description = "Ingress CIDR ranges. List of strings."
  type        = "list"
  default     = []
}

variable source_tags {
  description = "Source network tags. List of strings."
  type        = "list"
  default     = []
}

variable target_tags {
  description = "Destination network tags. List of strings."
  type        = "list"
  default     = []
}

variable source_service_accounts {
  description = "A list of service accounts such that the firewall will apply only to traffic originating from an instance with a service account in this list. Cannot be used at the same time as source_tags or target_tags. List of strings."
  type        = "list"
  default     = []
}

variable target_service_accounts {
  description = "A list of service accounts indicating sets of instances located in the network that may make network connections as specified in deny. List of strings."
  type        = "list"
  default     = []
}