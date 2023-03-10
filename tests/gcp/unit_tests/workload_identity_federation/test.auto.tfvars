project_id = "project-id"
workload_identity_pool = {
  pool_id: "cicd"
  providers = {
    bitbucket = {
      attribute_mapping = {
        "google.subject" = "assertion.sub"
        "attribute.tid"  = "assertion.tid"
        "attribute.git_ref" = null
      }
      owner = "companyWorkspace"
      workspace_uuid = "{company-unique-id}"
      oidc  = {
        issuer = "bitbucket-pipelines"
      }
    }
    circleci = {
      owner = "company"
      oidc = {
        issuer = "circleci"
      }
    }
    github = {
      attribute_condition = "assertion.repository_owner=='companyOrg' && assertion.ref=='refs/head/main'"
      attribute_mapping   = {
        "google.subject"  = "overwrite.sub"
        "attribute.actor" = "assertion.actor"
        "attribute.aud"   = "assertion.aud"
      }
      owner = "companyOrg"
      oidc  = {
        issuer = "github-actions"
      }
    }
    gitlab = {
      owner = "companyGroup"
      oidc = {
        issuer = "gitlab"
      }
    }
    terraform-cloud = {
      owner = "organization"
      oidc = {
        issuer = "terraform-cloud"
      }
    }
    unknown = {
      attribute_mapping = {
        "google.subject" = "assertion.other"
        "attribute.tid"  = "assertion.tid"
      }
      oidc = {
        issuer = "https://unknown.issuer"
        allowed_audiences = ["audience1", "audience2"]
      }
    }
  }
}
