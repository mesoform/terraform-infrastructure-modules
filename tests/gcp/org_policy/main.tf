variable organization_policies {
  type = map(map(string))

}
variable folder_policies {
  type = map(map(string))

}
variable project_policies {
  type = map(map(string))

}
module organization_policies {
  source = "../../../gcp/resource-manager/organization_policy"

  organization_id = "98765432100"
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
