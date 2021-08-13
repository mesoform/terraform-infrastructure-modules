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

variable "combining_function" {
  type = string
  default = "AND"

  validation {
    condition = contains(["AND", "OR"], var.combining_function)
    error_message = "Invalid combining function. Possible values are AND and OR."
  }
}

variable "conditions" {
  type = list(object({
    ip_subnetworks = optional(list(string))
    required_access_levels = optional(list(string))
    members = optional(list(string))
    regions = optional(list(string))
    negate = optional(bool)
  }))

  default = []

  validation {
    condition = can(regex("(user|serviceAccount):.*@.*"), var.conditions.members)
    error_message = "Allowed format for members (users/service accounts) is either user:{emailid} or serviceAccount:{emailid}"
  }
  validation {
    condition = contains([true,false], var.conditions.negate)
    error_message = "Boolean argument. Possible values are true or false."
  }
}
