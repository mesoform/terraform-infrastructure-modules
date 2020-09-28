//noinspection HILUnresolvedReference
locals {
  user_cloudrun_config_yml = fileexists(var.gcp_cloudrun_yml) ? file(var.gcp_cloudrun_yml) : ""
  cloudrun = yamldecode(local.user_cloudrun_config_yml)

  cloudrun_specs = lookup(local.cloudrun.components, "specs", {})
  cloudrun_iam = {
    for key, specs in local.cloudrun_specs:
      key => lookup(local.cloudrun_specs[key], "iam", {})
  }
  cloudrun_iam_members = {
    for key, specs in local.cloudrun_iam:
      key => lookup(local.cloudrun_iam[key],"members", null) == null ? []: [
        for user, tag in local.cloudrun_iam[key].members : "${tag}:${user}"
      ]
  }
  cloudrun_traffic = {
    for key, specs in local.cloudrun_specs:
      key => lookup(local.cloudrun_specs[key], "traffic", null) == null ? [] : [
        for setting in lookup(local.cloudrun_specs[key], "traffic", {}) :
          merge(setting, {latest_revision = lookup(setting, "revision_name", null) == null ? true: false})
    ]
  }

//  lookup(local.cloudrun_specs, "traffic", {}) == null ? {} : {
//    for service, setting in local.cloudrun_specs :
//      service => merge(setting, {latest_revision = lookup(setting, "revision_name", null) == null ? true: false})
//  }
}


//cloudrun_traffic = lookup(local.cloudrun_specs, "traffic", {}) == null ? [] : [
//for setting in lookup(local.cloudrun_specs, "traffic", {}) :
//merge(setting, {latest_revision = lookup(setting, "revision_name", null) == null ? true: false})
//]