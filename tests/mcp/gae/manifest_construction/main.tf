//tests ran from the test directory
//(gaz@gMacBookPro)-(12:40:56):manifest_construction/
//$ terraform init
//(gaz@gMacBookPro)-(12:38:08):manifest_construction/
//$ terraform plan -var-file resources/single_manifest.tfvars -out my.plan 2>&1 > /dev/null && terraform show -json my.plan | jq .planned_values.outputs && rm my.plan
//{
//  "test_src_files_sha1sum_lookup": {
//    "sensitive": false,
//    "value": {
//      "result": "pass"
//    }
//  },
//  "test_upload_manifest_format": {
//    "sensitive": false,
//    "value": {
//      "result": "pass"
//    }
//  }
//}

data external test_upload_manifest_format {
  query = local.upload_manifest
  program = ["/usr/local/bin/python3", "${path.module}/test_data_upload.py"]
}

data external test_src_files_sha1sum_lookup {
  query = lookup(local.file_sha1sums, "app1", {})
  program = ["/usr/local/bin/python3", "${path.module}/test_app_sha1sums.py"]
}

output test_upload_manifest_format {
  value = data.external.test_upload_manifest_format.result
}

output test_src_files_sha1sum_lookup {
  value = data.external.test_src_files_sha1sum_lookup.result
}
