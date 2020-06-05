//expected logic for constructing a manifest suitable for uploads
locals {
  single_user_gae_config_yml = file("./single_manifest.yml")
  single_gae = yamldecode(local.single_user_gae_config_yml)
  //noinspection HILUnresolvedReference
  single_as_all_specs = {
    for as, config in local.single_gae.components.specs:
      #This doesn't merge complex maps. Any nested map requirements need to handled at the property
      # level. See env_variables below
      as => merge(lookup(local.single_gae.components, "common", {}), config)
  }
  single_manifest_files = {
    for as, spec in local.single_as_all_specs:
          as => lookup(spec, "manifest_path", null)
          if lookup(spec, "manifest_path", null) != null
  }
  //noinspection HILUnresolvedReference
  single_src_files = flatten([
    for manifest_path in values(local.single_manifest_files): [
      for src_file in jsondecode(file(manifest_path)): [
        src_file
      ]
    ]
  ])
  //noinspection HILUnresolvedReference
  single_complete_manifest = {
    for file_config in local.single_src_files:
        file_config => filesha1("${path.cwd}/../../${file_config}")
  }
}

//simulate google_storage_bucket_object
resource local_file single_google_storage_bucket_object {
  for_each = local.single_complete_manifest
  content     = each.value
  filename = "/tmp/${each.key}"
}

data external single_test_src_files_manifest_format {
  depends_on = [local_file.single_google_storage_bucket_object]
  query = {
    for storage_file in local_file.single_google_storage_bucket_object:
      storage_file.filename => storage_file.content
  }
  program = ["/usr/local/bin/python3", "${path.module}/single_test_data_upload.py"]
}

data external single_test_filepath_key {
  query = {
    for full_path in keys(local.single_complete_manifest):
      element(regex("^.*/(.*)", full_path), 0) => ""
  }
  program = ["/usr/local/bin/python3", "${path.module}/single_test_filepath_key.py"]
}

output filepath_regex {
  value = {
    for full_path in keys(local.single_complete_manifest):
      element(regex("^.*/(.*)", full_path), 0) => ""
  }
}

output single_complete_manifest {
  value = local.single_complete_manifest
}
output single_test_src_files_manifest_format {
  value = data.external.single_test_src_files_manifest_format.result
}
output single_test_filepath_key {
  value = data.external.single_test_filepath_key.result
}