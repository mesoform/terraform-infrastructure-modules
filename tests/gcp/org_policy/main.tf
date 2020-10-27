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
}

data external test_complete_org_policy_map_construction {

  query = local.org_resourceLocations_allow
  program = ["python", "${path.module}/test_complete_org_policy_map_construction.py"]
}

output test_complete_org_policy_map_construction {
  value = data.external.test_complete_org_policy_map_construction.result
}