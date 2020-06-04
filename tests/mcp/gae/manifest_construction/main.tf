//expected logic for constructing a manifest suitable for uploads
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

//simulate google_storage_bucket_object
resource "local_file" "google_storage_bucket_object" {
  for_each = local.complete_manifest
  content     = each.key
  filename = "/tmp/${each.value}"
}

data "external" "test" {
  query = {
    for storage_file in local_file.google_storage_bucket_object:
      storage_file.filename => storage_file.content
  }
  program = ["/usr/local/bin/python3", "${path.module}/test_data_upload.py"]
}

output "test_result" {
  value = data.external.test.result
}