resource google_access_context_manager_service_perimeter self {
  name = "${var.access_policy_name}/service_perimeters/${var.name}"
  parent = var.access_policy_name
  title = var.perimeter_name
  perimeter_type = "PERIMETER_TYPE_REGULAR"

  status {
    restricted_services = var.restricted_services
    access_levels = []
    vpc_accessible_services {
      enable_restriction = var.restricted_services == [] ? false : true
      allowed_services   = var.restricted_services == [] ? null : var.restricted_services
    }
  }

  spec {}
}