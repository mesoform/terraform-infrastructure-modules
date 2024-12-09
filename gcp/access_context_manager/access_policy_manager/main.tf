data google_organization self {
  domain = var.organization_domain
}

resource google_access_context_manager_access_policy self {
  parent = data.google_organization.self.name
  title  = var.organization_domain
  scopes = [var.access_policy_scope]
}

resource google_access_context_manager_access_level self {
  for_each = var.access_levels
  name   = each.value.name
  parent = google_access_context_manager_access_policy.self.name
  title  = each.value.title
  dynamic basic {
    for_each = each.value.basic_conditions
    content {
      combining_function = basic.value.combining_function
      dynamic conditions {
        for_each = basic.value.conditions
        content {
          negate = conditions.value.negate
          ip_subnetworks = conditions.value.ip_subnetworks
          regions = conditions.value.regions
        }
      }
    }
  }
}