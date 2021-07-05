# Access Policy Manager

Takes the domain of a google organization as `organization_domain` and creates the main access context policy for the organization.

```hcl
module access_manager {
  source = "github.com/mesoform/terraform-infrastructure-modules//gcp/access_context_manager/access_policy_manager"
  organization_domain = "example.com"
}
```