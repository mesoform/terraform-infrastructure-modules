variable organization_policies {
  type = list(map(string))
}
variable folder_policies {
  type = list(map(string))
}
variable project_policies {
  type = list(map(string))
}
variable organization_id {
  type = string
}

locals {
  org_resourceLocations_allow = {
    allow_value: element(
      lookup(
        lookup(
          lookup(
            local.organization_level_policies,
            "gcp.resourceLocations-98765432100"),
          "list_policy"),
        "allow"),
    0)
  }
  project_resourceLocations_restore = {
    default_value: lookup(
        lookup(
          lookup(
            local.project_level_policies,
            "gcp.resourceLocations-mcp-testing-23452432"),
          "restore_policy"),
        "default"
    )
  }
  folder_serviceuser_deny = {
    deny_value: element(
      lookup(
        lookup(
          lookup(
            local.folder_level_policies,
            "serviceuser.services-323203379966"),
          "list_policy"),
        "deny"),
    0)
  }
}

data external test_list_org_policy_allow_value {
  query = local.org_resourceLocations_allow
  program = ["python", "${path.module}/test_list_org_policy_allow_value.py"]
}
output test_complete_org_policy_map_construction {
  value = data.external.test_list_org_policy_allow_value.result
}

data external test_restore_project_policy_default_value {
  query = local.project_resourceLocations_restore
  program = ["python", "${path.module}/test_restore_project_policy_default_value.py"]
}
output test_restore_project_policy_default_value {
  value = data.external.test_restore_project_policy_default_value.result
}

data external test_list_folder_policy_deny_value {
  query = local.folder_serviceuser_deny
  program = ["python", "${path.module}/test_list_folder_policy_deny_value.py"]
}
output test_list_folder_policy_deny_value {
  value = data.external.test_list_folder_policy_deny_value.result
}
