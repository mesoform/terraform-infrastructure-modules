//expected logic for constructing a manifest suitable for uploads
locals {
  user_gae_config_yml = file("./multiple_manifest.yml")
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
        file_config => filesha1("${path.cwd}/../../${file_config}")
  }
}

//simulate google_storage_bucket_object
resource "local_file" "google_storage_bucket_object" {
  for_each = local.complete_manifest
  content     = each.value
  filename = "/tmp/${each.key}"
}

resource "local_file" "regex_path" {
  for_each = local.complete_manifest
  filename = "/tmp/${element(regex("^.*/(.*)", each.key), 0)}"
}

data "external" "test_src_files_manifest_format" {
  depends_on = [local_file.google_storage_bucket_object]
  query = {
    for storage_file in local_file.google_storage_bucket_object:
      storage_file.filename => storage_file.content
  }
  program = ["/usr/local/bin/python3", "${path.module}/test_data_upload.py"]
}

//data "external" "test_filepath_key" {
//  depends_on = [local_file.regex_path]
//  query = {
//    for storage_file in local_file.regex_path:
//      storage_file.filename => ""
//  }
//  program = ["/usr/local/bin/python3", "${path.module}/test_filepath_key.py"]
//}

output complete_manifest {
  value = local.complete_manifest
}
output test_src_files_manifest_format_result {
  value = data.external.test_src_files_manifest_format.result
}

//output test_filepath_key_result {
//  value = data.external.test_filepath_key.result
//}