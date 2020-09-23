//noinspection HILUnresolvedReference
locals {
  user_cloudrun_config_yml = fileexists(var.gcp_cloudrun_yml) ? file(var.gcp_cloudrun_yml) : ""
  cloudrun = yamldecode(local.user_cloudrun_config_yml)

  cloudrun_specs = local.cloudrun.components.specs
  cloudrun_iam = lookup(local.cloudrun.components.specs, "iam", {})
  cloudrun_iam_members = lookup(local.cloudrun_iam, "members", null)==null ? [] : [for user, tag in local.cloudrun_iam.members : "${tag}:${user}"]
  cloudrun_traffic = lookup(local.cloudrun_specs, "traffic", {}) == null ? [] : [
    for setting in lookup(local.cloudrun_specs, "traffic", {}) :
      merge(setting, {latest_revision = lookup(setting, "revision_name", null) == null ? true: false})
  ]
}