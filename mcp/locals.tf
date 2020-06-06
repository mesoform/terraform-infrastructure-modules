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
  as_paths = {
    for as, spec in local.as_all_specs:
          as => {
            build_dir: format("../%s/%s", lookup(spec, "root_dir", as), lookup(spec, "build_dir", "build"))
            manifest: format("../%s/%s/mmcf-manifest.json", lookup(spec, "root_dir", as), lookup(spec, "build_dir", "build"))
          }
  }
  manifests = {
    for as, path in local.as_paths:
        as => jsondecode(file(path.manifest))
        if fileexists(path.manifest)
  }

  //noinspection HILUnresolvedReference
  file_sha = {
    for as, manifest in local.manifests:
          as => {
            for src_file in manifest.contents:
              src_file => filesha1(formatlist("%s/%s/%s", lookup(lookup(local.as_paths, as), "build_dir"), manifest.artifactDir, manifest.contents))
          }
  }


  //noinspection HILUnresolvedReference
  src_files = local.manifests == [] ? [] : flatten([
    for as, manifest in local.manifests:
      formatlist("%s/%s/%s", lookup(lookup(local.as_paths, as), "build_dir"), manifest.artifactDir, manifest.contents)
  ])
  //noinspection HILUnresolvedReference
  complete_manifest = local.src_files == [] ? {} : {
    for file_config in local.src_files:
        file_config => filesha1("${path.module}/../${file_config}")
  }
}
