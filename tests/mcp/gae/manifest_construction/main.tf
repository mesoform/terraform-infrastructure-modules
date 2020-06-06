//
////simulate google_storage_bucket_object
//resource local_file single_google_storage_bucket_object {
//  for_each = local.single_complete_manifest
//  content     = each.value
//  filename = "/tmp/${each.key}"
//}
//
//data external single_test_src_files_manifest_format {
//  depends_on = [local_file.single_google_storage_bucket_object]
//  query = {
//    for storage_file in local_file.single_google_storage_bucket_object:
//      storage_file.filename => storage_file.content
//  }
//  program = ["/usr/local/bin/python3", "${path.module}/single_test_data_upload.py"]
//}
//
//data external single_test_filepath_key {
//  query = {
//    for full_path in keys(local.single_complete_manifest):
//      element(regex("[[:ascii:]]/(.*)$", full_path), 0) => ""
//  }
//  program = ["/usr/local/bin/python3", "${path.module}/single_test_filepath_key.py"]
//}
//
//output single_filepath_regex {
//  value = {
//    for full_path in keys(local.single_complete_manifest):
//      element(regex("[[:ascii:]]/(.*)$", full_path), 0) => ""
//  }
//}
//
//output single_complete_manifest {
//  value = local.single_complete_manifest
//}
//output single_test_src_files_manifest_format {
//  value = data.external.single_test_src_files_manifest_format.result
//}
//output single_test_filepath_key {
//  value = data.external.single_test_filepath_key.result
//}

//simulate google_storage_bucket_object
resource "local_file" "google_storage_bucket_object" {
  for_each = local.complete_manifest
  content     = each.value
  filename = "/tmp/${each.key}"
}

//resource "local_file" "regex_path" {
//  for_each = local.complete_manifest
//  filename = "/tmp/${element(regex("[[:ascii:]]/(.*)$", each.key), 0)}"
//}

data "external" "test_src_files_manifest_format" {
  depends_on = [local_file.google_storage_bucket_object]
  query = {
    for storage_file in local_file.google_storage_bucket_object:
      storage_file.filename => storage_file.content
  }
  program = ["/usr/local/bin/python3", "${path.module}/test_data_upload.py"]
}

data external test_filepath_key {
  query = {
    for full_path in keys(local.complete_manifest):
      element(regex("[[:ascii:]]/(.*)$", full_path), 0) => ""
  }
  program = ["/usr/local/bin/python3", "${path.module}/single_test_filepath_key.py"]
}

output filepath_regex {
  value = {
    for full_path in keys(local.complete_manifest):
      element(regex("[[:ascii:]]/(.*)$", full_path), 0) => ""
  }
}

output as_all_specs {
  value = local.as_all_specs
}
output manifest_paths {
  value = local.manifest_paths
}
output manifests {
  value = local.manifests
}
output src_files {
  value = local.src_files
}

output complete_manifest {
  value = local.complete_manifest
}
output test_src_files_manifest_format_result {
  value = data.external.test_src_files_manifest_format.result
}

output test_filepath_key_result {
  value = data.external.test_filepath_key.result
}

