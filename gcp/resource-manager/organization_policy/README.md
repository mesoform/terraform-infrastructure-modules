# Google Cloud Organization Policy

## How to use this module

Create a deployment module as follows but pointing the source to this repository and directory
```hcl-terraform
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
  
  organization_id = "987654321000"
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

```

Pass in values in a format like below
```json
{
  "organization_policies": {
    "iam.disableServiceAccountKeyUpload": {
      "enforced": "true"
    },
    "serviceuser.services": {
      "deny": "doubleclicksearch.googleapis.com resourceviews.googleapis.com"
    }
  },
  "folder_policies": {
    "serviceuser.services": {
      "folder_number": "123345364",
      "inherit_from_parent": "false",
      "deny": "resourceviews.googleapis.com"
    }
  },
  "project_policies": {
    "serviceuser.services": {
      "project_id": "mesoform",
      "restore_default": "true"
    }
  }
}
```