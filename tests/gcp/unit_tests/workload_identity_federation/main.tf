//noinspection HILUnresolvedReference
data external test_oidc_provider_issuers {
  query   = {
    for provider, specs in local.identity_pool_providers :
      provider => specs.oidc.issuer
    if lookup(specs, "oidc", null) != null
  }
  program = ["python", "${path.module}/test_oidc_provider_issuers.py"]
}
output test_oidc_provider_issuers {
  value = data.external.test_oidc_provider_issuers.result
}

//noinspection HILUnresolvedReference
data external test_oidc_provider_audiences {
  query   = {
    for provider, specs in local.identity_pool_providers :
      provider => join(", ", lookup(specs.oidc, "allowed_audiences", []))
    if lookup(specs, "oidc", null) != null
  }
  program = ["python", "${path.module}/test_oidc_provider_audience.py"]
}
output test_oidc_provider_audiences {
  value = data.external.test_oidc_provider_audiences.result
}

//noinspection HILUnresolvedReference
data external test_provider_subject_attribute {
  query   = {
    for provider, specs in local.identity_pool_providers :
      provider => specs.attribute_mapping["google.subject"]
    if lookup(specs, "oidc", null) != null
  }
  program = ["python", "${path.module}/test_provider_subject_attribute.py"]
}
output test_provider_subject_attribute {
  value = data.external.test_provider_subject_attribute.result
}

//noinspection HILUnresolvedReference
data external test_oidc_provider_attributes {
  query   = { for key, value in local.identity_pool_providers.bitbucket.attribute_mapping: key => value if value != null}
  program = ["python", "${path.module}/test_provider_attributes.py"]
}
output test_oidc_provider_attributes {
  value = data.external.test_oidc_provider_attributes.result
}

//noinspection HILUnresolvedReference
data external test_provider_conditions {
  query   = {
    for provider, specs in local.identity_pool_providers :
      provider => lookup(specs, "attribute_condition", null) == null ? "none": specs.attribute_condition
    if lookup(specs, "oidc", null) != null
  }
  program = ["python", "${path.module}/test_provider_conditions.py"]
}
output test_provider_conditions {
  value = data.external.test_provider_conditions.result
}
