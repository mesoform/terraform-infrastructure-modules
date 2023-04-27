# Workload Identity Federation

This module deploys a Workload Identity Pool (WIP), and it's Providers (WIP Providers), for Workload Identity Federation.
[Workload Identity Federation](https://cloud.google.com/iam/docs/workload-identity-federation) allows external entities
to access Google Cloud resources without using service account keys.

This module implements templated configurations for commonly used external entities that use OIDC, including:
* Azure
* Bitbucket Pipelines
* CircleCi
* GitHub Actions
* GitLab
* Terraform Cloud

See the [configuration](#configuration) section for implementation details.

## Configuration
This module takes the following variables:
* `project_id` - The project the WIP is created in
* `pool_id` - ID for the WIP 
* `display_name` (optional) - The display name for the WIP, if different than the pool_id
* `description` (optional) - Description for the WIP
* `disabled` (optional) - Whether the WIP is disabled (default `false`)
* `workload_identity_pool_providers` - A map of WIP providers, with the provider ID's as the keys and the following 
attributes:

| Key                      |     Type     | Required | Description                                                                                                                            |                                                           Default                                                           |
|:-------------------------|:------------:|:--------:|:---------------------------------------------------------------------------------------------------------------------------------------|:---------------------------------------------------------------------------------------------------------------------------:|
| `attribute_mapping`      | map(string)  |  false   | Maps attributes from OIDC claim to google attributes. `google.sub` is required, e.g. `google.sub=assertion.sub`                        |                                                            none                                                             |
| `display_name`           |    string    |  false   | Display name for the provider                                                                                                          |                                                         provider-id                                                         |
| `description`            |    string    |  false   | Description for the provider                                                                                                           |                                                            none                                                             |
| `disabled`               |     bool     |  false   | Whether the provider is disabled                                                                                                       |                                                            false                                                            |
| `attribute_condition`    |    string    |  false   | An expression to define required values for assertion claims                                                                           |                                                            none                                                             |
| `owner`                  |    string    |  false   | If using a preconfigured `oidc.issuer` this references the "owner" of the issuer, i.e. the organization or username.                   |                                                            none                                                             |
| `workspace_uuid`         |    string    |  false   | If `oidc.issuer` is `bitbucket-pipelines`, this references the workspace uuid with the format: `XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX`  |                                                            none                                                             |
| `oidc`                   |     map      |  false   | The configuration for an OIDC provider (Either this OR `aws` block can be set)                                                         |                                                            none                                                             |
| `oidc.issuer`            |    string    |   true   | The preconfigured template to use, or the OIDC issuer uri                                                                              |                                                            none                                                             |
| `oidc.allowed_audiences` | list(string) |  false   | Acceptable values for the `aud` field                                                                                                  | `"https://iam.googleapis.com/projects/project-number/locations/global/workloadIdentityPools/pool-id/providers/provider-id"` |
| `aws`                    |     map      |  false   | The configuration for an AWS provider (Either this OR `oidc` block can be set)                                                         |                                                            none                                                             |
| `aws.account_id`         |     map      |   true   | The id of the client aws account                                                                                                       |                                                            none                                                             |

#### Example
```terraform
module workload_identity_pool {
  source                 = "github.com/mesoform/terraform-infrastructure-modules//gcp/iam/workload_identity_federation"
  project_id             = "project_id"
  pool_id = "cicd"
  display_name = "CI/CD pool"
  workload_identity_pool_providers = {
    github-company1 = {
      attribute_condition = "assertion.repostory_owner=='company1' && assertion.actor=='personalAccount'"
      attribute_mapping   = {
        "google.subject"  = "assertion.repository"
      }
      owner = "company1"
      oidc  = {
        issuer = "github-actions"
      }
    }
    bitbucket-mesoform = {
       owner          = "mesoform"
      workspace_uuid = "some-uuid"
      oidc           = {
        issuer = "bitbucket-pipelines"
      }
    }
    unknown = {
      attribute_mapping = {
        "google.subject" = "assertion.sub"
        "attribute.tid"  = "assertion.tid"
      }
      oidc = {
        issuer = "https://unknown.issuer"
      }
    }
  } 
}
```

Multiple pools can be configured at once using a `for_each` attribute, e.g.:
```terraform
module workload_identity_pools {
  source                           = "github.com/mesoform/terraform-infrastructure-modules//gcp/iam/workload_identity_federation"
  for_each                         = var.workload_identity_pools
  project_id                       = var.project_id
  pool_id                          = each.value.pool_id
  display_name                     = lookup(each.value, "display_name", null)
  description                      = lookup(each.value, "description", "")
  workload_identity_pool_providers = lookup(each.value, "providers", null)
}
```
where `var.workload_identity_pools` is defined as:
```terraform
workload_identity_pools = {
  cicd = {
    pool_id      = "cicd"
    display_name = "CI/CD pool"
    providers    = {
      github-company1 = {
        display_name = "Company1 Github"
        attribute_condition = "assertion.repostory_owner=='company1' && assertion.actor=='personalAccount'"
        attribute_mapping   = {
          "google.subject" = "assertion.repository"
        }
        owner = "company1"
        oidc  = {
          issuer = "github-actions"
        }
      }
      bitbucket-mesoform = {
        owner          = "mesoform"
        workspace_uuid = "some-uuid"
        oidc           = {
          issuer = "bitbucket-pipelines"
        }
      }
      unknown = {
        attribute_mapping = {
          "google.subject" = "assertion.sub"
          "attribute.tid"  = "assertion.tid"
        }
        oidc = {
          issuer = "https://unknown.issuer"
        }
      }
    }
  }
  aws = {
    pool_id      = "aws"
    display_name = "AWS applications"
    providers    = {
      ec2_instance_1 = {
        attribute_condition = "assertion.arn.startsWith('arn:aws:sts::accountid:assumed-role/')"
        attribute_mapping   = {
          "google.subject"             = "assertion.arn"
          "attribute.account"          = "assertion.account"
          "attribute.aws_role"         = "assertion.arn.extract('assumed-role/ROLE/')"
          "attribute.aws_ec2_instance" = "assertion.arn.extract('assumed-role/ROLE_AND_SESSION').extract('/SESSION')"
        }
        aws = {
          account_id = "accountid"
        }
      }
    }
  }
}
```

### Preconfigured defaults
This module has preconfigured Identity Provider settings for commonly used clients, referred to as "trusted issuers",
which can be used by setting `providers.oidc.issuer` to one of the issuers from the table below, 
as well as setting the required attributes for the `workload_identity_pools` provider.

Full defaults for preconfigured WIP Provider can be found in the [`trusted_issuers.tf`](./trusted_issuers.yaml) file.

#### Trusted issuers
| Issuer                | Required variable value                                                               |
|-----------------------|---------------------------------------------------------------------------------------|
| `azure`               | - `owner`: Tenant ID of Azure tenant                                                  |
| `bitbucket-pipelines` | - `owner`: Name of the workspace owner <br> - `workspace_uuid`: UUid of the workspace |
| `circleci`            | - `owner`: CircleCi Organization ID                                                   |
| `github-actions`      | - `owner`: Repository owner (i.e. Username/Organization)                              |
| `gitlab`              | - `owner`: Unique group ID                                                            |
| `terraform-cloud`     | - `owner`: Terraform Cloud Organization ID                                            |

#### Changing default values
##### attribute_mapping:
The `attribute_mapping` values can be overwritten by specifying a different value for preconfigured keys.
If a preconfigured key is unwanted it can be set to null, e.g. `"attribute.git_ref" = null`.

##### attribute_condition:
Each of the providers have a condition configured based on the `owner`/`workspace_uuid` attributes, 
ensuring .
To make a custom condition configure set the `attribute_condition` to a [valid condition](https://cloud.google.com/iam/docs/workload-identity-federation#conditions).

> **WARNING**: Some claims don't include the unique attributes, so tokens issued by other owners could have similar values. 
> If the condition is not appropriately set to limit access, 
> other users or users outside your organization could end up with access to your resources

##### audience:
The client's audience is extracted from the `aud` claim in the token, and by default is expected to be the address of the resource server
(i.e. `https://iam.googleapis.com/projects/PROJECT_NUMBER/locations/global/workloadIdentityPools/POOL_ID/providers/PROVIDER_ID`).
Some tokens, provided by some of the above issuers, have a different default `aud` value specified, 
so the preconfigured `allowed_audiences` attribute is set to match that.
If the default audience should be included in the `allowed_audiences` as well as the preconfigured default,
add `"default"` to the list in `oidc.allowed_audiences`.   
e.g.
```terraform
workload_identity_pool = {
  pool_id      = "cicd"
  display_name = "CI/CD pool"
  providers    = {
    bitbucket = {
      owner          = "workspaceName"
      workspace_uuid = "some-uuid"
      oidc           = {
        issuer = "bitbucket-pipelines"
        allowed_audiences = ["default"]
      }
    }
  }
}
```

If the Google default audience is the only audience that should be the only allowed audience,
but the truster issuer has a preconfigured default audience, the provider must be configured manually.
e.g.

```terraform
workload_identity_pool = {
  pool_id      = "cicd"
  display_name = "CI/CD pool"
  providers    = {
    bitbucket = {
      attributes = {
        "google.subject" = "assertion.sub"
        "attribute.workspace_uuid" = "assertion.workspaceUuid"
        "attribute.repository" = "assertion.repositoryUuid"
        "attribute.git_ref" = "assertion.branchName"
      }
      oidc           = {
        issuer = "https://api.bitbucket.org/2.0/workspaceName/goup/pipelines-config/identity/oidc"
        allowed_audiences = ["default"] # (or don't define the block)
      }
      attribute_condition = "assertion.workspaceUuid=='${some-uuid}'"
    }
  }
}
```