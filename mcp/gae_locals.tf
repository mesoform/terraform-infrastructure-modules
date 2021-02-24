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
  // If environment variables exist, use that, otherwise use traffic file.
  //`yamldecode`var.gcp_ae_traffic` is to make tha condition fail if not met, as there is no exit function in terraform
  gae_traffic_config   = try(var.gcp_ae_traffic != null ? var.gcp_ae_traffic : yamldecode(var.gcp_ae_traffic) , yamldecode(file(var.gcp_ae_traffic_yml)), {})

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
    for as, spec in local.as_all_specs:
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

  env_variables = {
    for as, specs in local.as_all_specs: as => merge(
      lookup(local.gae_components, "common", null ) == null ? {} : lookup(local.gae_components.common, "env_variables", {}),
      lookup(specs, "env_variables", {}))
  }

  gae_traffic = {
    for as, specs in local.as_all_specs: as => {
      for version, percent in local.gae_traffic_config: element(regex(";(.*)", version),0) => percent/100
      if length(regexall("^${as};", version)) > 0
    }
  }

  gae_traffic_std = {
    for service, specs in local.as_std_specs: service =>
      lookup(local.gae_traffic, service, {}) == {} ? {lookup(specs, "version_id", "v1") = 1} : local.gae_traffic[service]
    if lookup(specs, "migrate_traffic", true) || length(lookup(local.gae_traffic, service, {} )) > 0
  }

  gae_traffic_flex = {
    for service, specs in local.as_flex_specs: service =>
      lookup(local.gae_traffic, service, {}) == {} ? {lookup(specs, "version_id", "v1") = 1} : local.gae_traffic[service]
    if lookup(specs, "migrate_traffic", true) || length(lookup(local.gae_traffic, service, {} )) > 0
  }


}

