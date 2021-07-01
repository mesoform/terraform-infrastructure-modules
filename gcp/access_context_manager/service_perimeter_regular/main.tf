resource google_access_context_manager_service_perimeter self {
  name = "accessPolicies/${var.access_policy_name}/servicePerimeters/${var.name}"
  parent = "accessPolicies/${var.access_policy_name}"
  title = var.name
  perimeter_type = "PERIMETER_TYPE_REGULAR"

  status {
    resources = local.resources
    restricted_services = local.restricted_services
    access_levels = [ for access_level in var.access_levels : "accessPolicies/${var.access_policy_name}/accessLevels/${access_level}"]
    vpc_accessible_services {
      enable_restriction = contains(local.vpc_accessible_services, "ALL-SERVICES" ) ? false : true
      allowed_services = contains(local.vpc_accessible_services, "ALL-SERVICES") ? local.vpc_sc_supported_services : local.vpc_accessible_services
    }
    dynamic ingress_policies {
      for_each = local.ingress_policies
      content {
        ingress_from {
          identity_type = lookup(ingress_policies.value, "ingressFrom", null) == null ? null : lookup(ingress_policies.value["ingressFrom"], "identityType", null)
          identities = lookup(ingress_policies.value, "ingressFrom", null) == null ? [] : lookup(ingress_policies.value["ingressFrom"], "identities", [])
          dynamic sources {
            for_each = lookup(ingress_policies.value["ingressFrom"], "sources", [])
            content {
              access_level = "accessPolicies/${var.access_policy_name}/accessLevels/${lookup(sources.value, "accessLevel", null)}"
              resource = lookup(sources.value, "resource", null)
            }
          }
        }
        ingress_to {
          resources = lookup(ingress_policies.value, "ingressTo", null) == null ? [] : lookup(ingress_policies.value["ingressTo"], "resources", [])
          dynamic operations {
            for_each = lookup(ingress_policies.value, "ingressTo", null) == null ? [] : lookup(ingress_policies.value["ingressTo"], "operations", [])
            content {
              service_name = lookup(operations.value, "serviceName", null)
              dynamic method_selectors {
                for_each = lookup(operations.value, "methodSelectors", [])
                content {
                  method = lookup(method_selectors.value, "method", null)
                  permission = lookup(method_selectors.value, "permission", null)
                }
              }
            }
          }
        }
      }
    }
    dynamic egress_policies {
      for_each = local.egress_policies
      content {
        egress_from {
          identity_type = lookup(egress_policies.value, "egressFrom", null) == null ? null : lookup(egress_policies.value["egressFrom"], "identityType", null)
          identities = lookup(egress_policies.value, "egressFrom", null) == null ? [] : lookup(egress_policies.value["egressFrom"], "identities", [])
        }
        egress_to {
          resources = lookup(egress_policies.value, "egressTo", null) == null ? [] : lookup(egress_policies.value["egressTo"], "resources", [])
          dynamic operations {
            for_each = lookup(egress_policies.value, "egressTo", null) == null ? [] : lookup(egress_policies.value["egressTo"], "operations", [])
            content {
              service_name = lookup(operations.value, "serviceName", null)
              dynamic method_selectors {
                for_each = lookup(operations.value, "methodSelectors", [])
                content {
                  method = lookup(method_selectors.value, "method", null)
                  permission = lookup(method_selectors.value, "permission", null)
                }
              }
            }
          }
        }
      }
    }
  }
  dynamic "spec" {
    for_each = var.dry_run_mode ? [true] : []
    content {}
  }
}