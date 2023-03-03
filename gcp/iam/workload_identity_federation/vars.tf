variable project_id {
  type = string
}

variable workload_identity_pool {
  type = object({
    pool_id = string
    display_name = optional(string, null)
    description = optional(string, "")
    disabled = optional(bool, false)
    providers = optional(map(object({
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
    })), {})
  })
}

