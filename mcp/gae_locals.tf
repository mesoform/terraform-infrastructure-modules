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
  as_paths = {
    for as, spec in local.as_all_specs :
      as => {
        build_dir : format("%s/%s", lookup(spec, "root_dir", as), lookup(spec, "build_dir", "build"))
        manifest : format("../%s/%s/mmcf-manifest.json", lookup(spec, "root_dir", as), lookup(spec, "build_dir", "build"))
    }
  }

  manifests = {
    for as, path in local.as_paths: as =>
      jsondecode(file(path.manifest))
      if fileexists(path.manifest)
  }

  src_files = {
    for as, manifest in local.manifests : as => {
      for path in manifest.contents: basename(path) =>
        "https://storage.googleapis.com/${lookup(local.gae, "bucket_name", local.gae.project_id)}/${local.as_paths[as].build_dir}/${manifest.artifactDir}/${path}"
    }
  }

}

