//noinspection HILUnresolvedReference
locals {
  user_cloudrun_config_yml  = fileexists(var.gcp_cloudrun_yml) ? file(var.gcp_cloudrun_yml) : null
  cloudrun                  = yamldecode(local.user_cloudrun_config_yml)
  cloudrun_components       = lookup(local.cloudrun, "components", {})
  cloudrun_components_specs = lookup(local.cloudrun_components, "specs", {})
  cloudrun_specs = {
    for key, specs in local.cloudrun_components_specs:
      key => merge(lookup(local.cloudrun_components, "common", {}), specs)
  }
  cloudrun_iam = {
    for key, specs in local.cloudrun_specs:
      key => lookup(local.cloudrun_specs[key], "iam", {})
  }
  cloudrun_iam_bindings = {
    for key, specs in local.cloudrun_iam:
      key => lookup(local.cloudrun_iam[key], "bindings", {})
  }
  cloudrun_traffic = {
    for key, specs in local.cloudrun_specs:
      key => lookup(local.cloudrun_specs[key], "traffic", null) == null ? [] : [
        for setting in lookup(local.cloudrun_specs[key], "traffic", {}) :
          merge(setting, {latest_revision = lookup(setting, "revision_name", null) == null ? true: false})
    ]
  }
}
