locals  {
  trusted_issuers_file = "${path.module}/trusted_issuers.yaml"

  identity_pool_providers_map_trusted = {
    for provider, specs in var.workload_identity_pool.providers: provider =>
      contains(keys(yamldecode(file(local.trusted_issuers_file))), try(specs.oidc.issuer, "null")) ? yamldecode(
        templatefile(local.trusted_issuers_file, {
          owner = specs.owner
          workspace_uuid = specs.workspace_uuid
        } ))[specs.oidc.issuer] : null
  }

  identity_pool_providers = {
    for provider, specs in var.workload_identity_pool.providers: provider => {
      project = var.project_id
      provider_id = provider
      display_name = lookup(specs, "display_name", provider)
      description = specs.description
      disabled = specs.disabled
      attribute_mapping = merge(
        lookup(local.identity_pool_providers_map_trusted, provider, null) == null ? {} : lookup(local.identity_pool_providers_map_trusted[provider], "attributes", {} ),
        lookup(specs, "attribute_mapping", {})
      )
      //noinspection HILUnresolvedReference
      attribute_condition = lookup(specs, "attribute_condition", null) == null ? try(
        local.identity_pool_providers_map_trusted[provider].condition,
        null
      ) : specs.attribute_condition
      oidc = lookup(specs, "oidc", null) == null ? null : {
        //noinspection HILUnresolvedReference
        issuer = lookup(local.identity_pool_providers_map_trusted, provider, null) == null ? specs.oidc.issuer : local.identity_pool_providers_map_trusted[provider].issuer
        //noinspection HILUnresolvedReference
        allowed_audiences = distinct(concat(
          try(local.identity_pool_providers_map_trusted[provider].allowed_audiences, []),
          specs.oidc.allowed_audiences
        ))
      }
      aws = lookup(specs, "aws", null) == null ? null : {
        account_id = specs.aws.account_id
      }
    }
  }
}