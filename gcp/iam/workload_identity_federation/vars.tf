variable project_id {
  description = "The project which the Workload Identity Pool will exist in"
  type = string
}

variable pool_id {
  description = "The id for the Workload Identity Pool"
  type = string
}

variable display_name {
  description = "Display name for the Workload Identity Pool (if different from the pool_id)"
  type = string
  default = null
}

variable description {
  description = "Description for the Workload Identity Pool"
  type = string
  default = ""
}

variable disabled {
  description = "Whether the Workload Identity Pool is disabled (default: false)"
  type = bool
  default = false
}

variable workload_identity_pool_providers {
  description = "Map of Workload Identity Pool Providers and their settings"
  type = map(object({
    attribute_mapping = optional(map(string))
    attribute_condition = optional(string)
    display_name = optional(string)
    description = optional(string)
    disabled = optional(bool, false)
    aws = optional(map(string))
    oidc = optional(object({
      issuer = string
      allowed_audiences = optional(list(string),[])
    }))
    owner = optional(string, "")
    workspace_uuid = optional(string, "")
  }))
  default = {}
}