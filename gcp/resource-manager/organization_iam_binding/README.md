# Google Cloud Organization IAM Policy

Manages identities and associated configuration per role

Can be used as follows

```terraform
google_organization_iam_roles = {
  "roles/resourcemanager.organizationAdmin": {
    members = ["group:security@mesoform.com"]
    conditions = [
      { title = "time_limited_access" expression = "request.time < timestamp(\"1977-07-08T00:00:00.00Z\")" }
    ]
  }
}

variable google_organization_iam_roles {
  type = map(object({
    members = list(string)
    conditions = list(object({
      title = string
      expression = string
    }))
  }))
}

module org_iam_role {
  for_each = var.google_organization_iam_roles
  source = "github.com/mesoform/terraform-infrastructure-modules/gcp/resource-manager/organization_iam_binding"
  role = each.key
  iam_binding = each.value
  google_org_id = var.google_org_id
}
```