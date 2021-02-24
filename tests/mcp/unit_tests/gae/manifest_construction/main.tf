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


data external test_manifest_to_src {
  query = local.src_files["app1"]
  program = ["python", "${path.module}/test_manifest_to_src.py"]
}
output test_src_files{
  value = data.external.test_manifest_to_src.result
}

data  external test_flex_std_app1_separation {
  query = {
    name: "app1"
    env: lookup(local.as_flex_specs, "app1", null) == null ? "" : lookup(local.as_flex_specs["app1"],"env", "" )
  }
  program = ["python", "${path.module}/test_flex_std_app1_separation.py"]
}
output test_flex_std_app1_separation {
  value = data.external.test_flex_std_app1_separation.result
}

// if we override `default` app to use `env: standard`, this should be an empty map
data external test_flex_std_default_separation {
  query = lookup(local.as_flex_specs, "default", {})
  program = ["python", "${path.module}/test_flex_std_default_separation.py"]
}
output test_flex_std_default_separation {
  value = data.external.test_flex_std_default_separation.result
}

data external test_env_variables {
  query = lookup(local.env_variables, "app1", {})
  program = ["python", "${path.module}/test_env_variables.py"]
}
output test_env_variables {
  value = data.external.test_env_variables.result
}

data external test_ae_traffic_flex {
  query = lookup(local.gae_traffic_flex, "app1", {})
  program = ["python", "${path.module}/test_ae_traffic_flex.py"]
}
output test_ae_traffic_flex {
  value = data.external.test_ae_traffic_flex.result
}

data external test_ae_traffic_std{
  query = lookup(local.gae_traffic_std, "app2", {})
  program = ["python", "${path.module}/test_ae_traffic_std.py"]
}
output test_ae_traffic_std {
  value = data.external.test_ae_traffic_std.result
}
