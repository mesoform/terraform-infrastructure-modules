//(gaz@gMacBookPro)-(23:34:58):manifest_construction/
//$ terraform apply -var-file resources/single_manifest.tfvars -auto-approve
//data.external.test_src_files_manifest_format: Refreshing state...
//
//Apply complete! Resources: 0 added, 0 changed, 0 destroyed.
//
//Outputs:
//
//test_upload_manifest_format = {
//  "result" = "pass"
//}

data external test_src_files_manifest_format {
//  depends_on = [local_file.google_storage_bucket_object]
  query = local.upload_manifest
  program = ["/usr/local/bin/python3", "${path.module}/test_data_upload.py"]
}

output test_upload_manifest_format {
  value = data.external.test_src_files_manifest_format.result
}
