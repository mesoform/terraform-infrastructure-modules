resource google_access_context_manager_access_level self {
  name = "accessPolicies/${var.access_policy_name}/accessLevels/${var.access_level_name}"
  parent = "accessPolicies/${var.access_policy_name}"
  title = var.access_level_name

  basic {
    combining_function = var.combining_function
    dynamic "conditions" {
      for_each = var.conditions
      content {
        ip_subnetworks = lookup(conditions.value, "ip_subnetworks", null)
        required_access_levels = lookup(conditions.value, "required_access_levels", null)
        members = lookup(conditions.value, "members", [])
        regions = lookup(conditions.value, "regions", null)
        negate = lookup(conditions.value, "negate", false)
      }
    }
  }
}
