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

  user_project_config_yml = file(var.user_project_config_yml)
  project = yamldecode(local.user_project_config_yml)
  user_gae_config_yml = file(var.gcp_ae_yml)
  gae = yamldecode(local.user_gae_config_yml)

  //noinspection HILUnresolvedReference
  as_all_map = {
    for as, config in local.gae.components.specs:
      #This doesn't merge complex maps. Any nested map requirements need to handled at the property
      # level. See env_variables below
      as => merge(lookup(local.gae.components, "common", {}), config)
  }
  //noinspection HILUnresolvedReference
  as_flex_specs = {
    for as, config in local.gae.components.specs:
      #This doesn't merge complex maps. Any nested map requirements need to handled at the property
      # level. See env_variables below
      as => merge(lookup(local.gae.components, "common", {}), config)
      if lookup(config, "env", "standard") == "flex"
  }
  //noinspection HILUnresolvedReference
  as_std_specs = {
    for as, config in local.gae.components.specs:
      as => merge(lookup(local.gae.components, "common", {}), config)
      if lookup(config, "env", "standard") == "standard"
  }
  //noinspection HILUnresolvedReference
  as_all_specs = {
    for as, config in local.gae.components.specs:
      #This doesn't merge complex maps. Any nested map requirements need to handled at the property
      # level. See env_variables below
      as => merge(lookup(local.gae.components, "common", {}), config)
  }
  //noinspection HILUnresolvedReference
  manifest_files = {
    for as, spec in local.as_all_specs:
          as => lookup(spec, "manifest_path", null)
          if lookup(spec, "manifest_path", null) != null
  }
  //noinspection HILUnresolvedReference
  src_files = flatten([
    for manifest_path in values(local.manifest_files): [
      for src_file in jsondecode(file(manifest_path)): [
        src_file
      ]
    ]
  ])
  //noinspection HILUnresolvedReference
  complete_manifest = {
    for file_config in local.src_files:
        file_config => filesha1("${path.cwd}/../${file_config}")
  }
}
