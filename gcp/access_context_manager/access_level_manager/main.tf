resource google_access_context_manager_access_level self {
  name = "accessPolicies/${var.access_policy_name}/accessLevels/${var.name}"
  parent = "accessPolicies/${var.access_policy_name}"
  title = var.name

  basic {
    conditions {
      ip_subnetworks = var.allowed_ip_subnetworks
      members = var.allowed_members
      }
    }
}