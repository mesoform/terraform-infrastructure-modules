variable organization_policies {
  type = list(map(string))
  default = []
}
variable folder_policies {
  type = list(map(string))
  default = []
}
variable project_policies {
  type = list(map(string))
  default = []
}
variable organization_id {
  type = string
}
module organization_policies {
  source = "../../../gcp/resource-manager/organization_policy"

  organization_id = var.organization_id
  organization_policies = var.organization_policies
  folder_policies = var.folder_policies
  project_policies = var.project_policies
}

output organization_level_policies {
  value = module.organization_policies.organization_level_policies
}
output folder_level_policies {
  value = module.organization_policies.folder_level_policies
}
output project_level_policies {
  value = module.organization_policies.project_level_policies
}
