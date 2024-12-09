# Access Policy Manager

Takes the domain of a google organization as `organization_domain` and creates the main access context policy for the organization.

```hcl
module access_manager {
  source              = "github.com/mesoform/terraform-infrastructure-modules//gcp/access_context_manager/access_policy_manager"
  organization_domain = "example.com"
  access_policy_scope = "folders/1234567890"
  access_levels       = [
    {
      title            = "my human title"
      name             = "my_name"
      basic_conditions = [
        {
          combining_function = "AND"
          conditions         = [
            {
              negate         = true
              ip_subnetworks = ["1.1.1.1/32"]
              regions        = ["GB"]
            }
          ]
        }
      ]
    }
  ]
}
```