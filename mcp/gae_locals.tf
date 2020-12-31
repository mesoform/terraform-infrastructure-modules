locals {
  default = {
    automatic_scaling = {
      target_utilization = 0.5
    }
    liveness_check = {
      path = "/"
    }
    readiness_check = {
      path = "/"
    }
  }
  user_gae_config_yml     = fileexists(var.gcp_ae_yml)? file(var.gcp_ae_yml) : null
  gae                     = try(yamldecode(local.user_gae_config_yml), {})
  gae_components          = lookup(local.gae, "components", {})
  gae_components_specs    = lookup(local.gae_components, "specs", {})

  //noinspection HILUnresolvedReference
  as_all_map = {
    for as, config in local.gae_components_specs:
      #This doesn't merge complex maps. Any nested map requirements need to handled at the property
      # level. See env_variables below
      as => merge(lookup(local.gae_components, "common", {}), config)
  }
  //noinspection HILUnresolvedReference
  as_flex_specs = {
    for as, config in local.gae_components_specs:
      #This doesn't merge complex maps. Any nested map requirements need to handled at the property
      # level. See env_variables below
      as => merge(lookup(local.gae_components, "common", {}), config)
      if lookup(merge(lookup(local.gae_components, "common", {}), config), "env", "standard") == "flex"
  }
  //noinspection HILUnresolvedReference
  as_std_specs = {
    for as, config in local.gae_components_specs:
      as => merge(lookup(local.gae_components, "common", {}), config)
      if lookup(merge(lookup(local.gae_components, "common", {}), config), "env", "standard") == "standard"
  }
  //noinspection HILUnresolvedReference
  as_all_specs = {
    for as, config in local.gae_components_specs:
      #This doesn't merge complex maps. Any nested map requirements need to handled at the property
      # level. See env_variables below
      as => merge(lookup(local.gae_components, "common", {}), config)
  }

  //noinspection HILUnresolvedReference
  as_file_manifest = {
    for as, specs in local.gae_components_specs:
      as => jsondecode(file(specs.value.files.manifest))
      if lookup(specs.deployment, "files", null) != null
  }
}

