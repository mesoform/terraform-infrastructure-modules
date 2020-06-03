locals {
  user_gae_config_yml = file("./gcp_ae.yml")
  gae = yamldecode(local.user_gae_config_yml)
  //noinspection HILUnresolvedReference
  as_all_specs = {
    for as, config in local.gae.components.specs:
      #This doesn't merge complex maps. Any nested map requirements need to handled at the property
      # level. See env_variables below
      as => merge(lookup(local.gae.components, "common", {}), config)
  }
  manifest_files = {
    for as, spec in local.as_all_specs:
          as => lookup(spec, "manifest_path", null)
          if lookup(spec, "manifest_path", null) != null
  }
  manifest_files_values = values(local.manifest_files)
  //noinspection HILUnresolvedReference
  combined_manifests = flatten([
    for manifest_path in values(local.manifest_files): [
      for manifest in jsondecode(file(manifest_path)): [
        manifest
      ]
    ]
  ])
  //noinspection HILUnresolvedReference
  complete_manifest = {
    for file_config in local.combined_manifests:
        file_config.path => file_config.sha1Sum
  }
}

output "specs" {
  value = local.as_all_specs
}

output "combined_manifests" {
  value = local.combined_manifests
}

output "complete_manifest" {
  value = local.complete_manifest
}

output "manifest_files" {
  value = local.manifest_files
}

output "manifest_file_values" {
  value = local.manifest_files_values
}