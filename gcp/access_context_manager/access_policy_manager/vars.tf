variable organization_domain {
  type = string
  description = "Domain of the organization"
}

variable access_policy_scope {
  type = string
  description = "The scope of the AccessPolicy. Scopes define which resources a policy can restrict and where its resources can be referenced."
  nullable = true
  default = null
#   validation {
#     condition = var.access_policy_scope
#     error_message = "Variable must begin with 'folders/' or 'projects/`"
#   }
}

variable access_levels {
  default = []
  nullable = true
  description = "A list of access levels to create on the access policy."
  type    = list(object({
    title = string
    name  = string
    basic_conditions = list(object({
      combining_function = string
      conditions = list(object({
        negate = bool
        ip_subnetworks = list(string)
        regions = list(string)
      }))
    }))
  }))
}