# Google Cloud Organization Policy

## Summary
Module created to separate out the creation and configuration of the policies from deployments code.
 In that, to add a new policy a user can simply add a new configuration to a map of strings. The 
 examples below show a static Terraform deployment configuration which only needs to update the JSON
 file to update or add new policies.
 
## Configuration
There are 3 levels of policy assignment, Organization, Folder and Project

### Common keys for each level
### list constraints
list constraints take one of `allow` or `deny` keys. Where the value is a string and the string is a
space separated list. `in:` and `is:`, as per the documentation for list constraints are allowed.
`"all"` is a special keyword which means all possible values for the policy
### boolean constraints
takes a single key, `enforced` which is a string representation of `true` or `false`
## restore default override
takes a single key, `restore_default` which is a string representation of `true` or `false`

### Organization level additional keys
Organization level takes no additional keys. The `organization_id` should be set as a first-class 
variable in the module block

### Folder level additional keys
Takes `project_id`, which is a string representation of the unique Google project ID. Also
`inherit_from_parent`, which is a string representation of `true` or `false`

### Project level additional keys
Takes `folder_number`, which is a string representation of the unique Google folder number. Also
`inherit_from_parent`, which is a string representation of `true` or `false`      

## How to use this module

Create a deployment module as follows but pointing the source to this repository and directory. If a
policy already exists on the platform, the deployment will overwrite the policy with the 
configuration defined in this module. *There is no platform 409 error about the policy already 
existing.*

```hcl-terraform
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
  source = "git:https://github.com/mesoform/terraform-infrastructure-modules.git//gcp/resource-manager/organization_policy"
  
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

```

Pass in values in a format like below
```json
{
  "organization_id": "98765432100",
  "organization_policies": [
    {
      "constraint": "gcp.resourceLocations",
      "allow": "in:europe-west2-locations"
    },
    {
      "constraint": "iam.disableServiceAccountKeyUpload",
      "enforced": "true"
    },
    {
      "constraint": "serviceuser.services",
      "deny": "doubleclicksearch.googleapis.com resourceviews.googleapis.com"
    }
  ],
  "folder_policies": [
    {
      "constraint": "serviceuser.services",
      "folder_number": "323203379966",
      "inherit_from_parent": "false",
      "deny": "resourceviews.googleapis.com"
    }
  ],
  "project_policies": [
    {
      "constraint": "serviceuser.services",
      "project_id": "mesoform-34234243",
      "restore_default": "true"
    },
    {
      "constraint": "gcp.resourceLocations",
      "project_id": "mcp-testing-23452432",
      "restore_default": "true"
    }
  ]
}
```