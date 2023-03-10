resource google_iam_workload_identity_pool self {
  project = data.google_project.self.project_id
  workload_identity_pool_id = replace(var.workload_identity_pool.pool_id, "_", "-")
  display_name = var.workload_identity_pool.display_name == null ?  var.workload_identity_pool.pool_id : var.workload_identity_pool.display_name
  description = var.workload_identity_pool.description
  disabled = var.workload_identity_pool.disabled
}

//noinspection HILUnresolvedReference
resource google_iam_workload_identity_pool_provider self {
  for_each = local.identity_pool_providers
  project = each.value.project
  workload_identity_pool_id = google_iam_workload_identity_pool.self.workload_identity_pool_id
  workload_identity_pool_provider_id = replace(each.value.provider_id, "_", "-")
  display_name = each.value.display_name
  description = each.value.description
  disabled = each.value.disabled
  attribute_mapping = each.value.attribute_mapping
  attribute_condition = each.value.attribute_condition
  //noinspection HILUnresolvedReference
  dynamic "aws" {
    for_each = lookup(each.value, "aws", null) == null ? {} : { aws = each.value.aws}
    //noinspection HILUnresolvedReference
    content {
      account_id = aws.value.account_id
    }
  }
  //noinspection HILUnresolvedReference
  dynamic "oidc" {
    for_each = lookup(each.value, "oidc", null) == null ? {} : { oidc = each.value.oidc }
    //noinspection HILUnresolvedReference
    content {
      issuer_uri = oidc.value.issuer
      allowed_audiences = [ for audience in lookup(oidc.value, "allowed_audiences", []):
        (audience == "default" ? format(local.default_audience, replace(each.value.provider_id, "_", "-")) : audience)
      ]
    }
  }
}