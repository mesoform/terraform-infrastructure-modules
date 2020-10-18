data external test_policy_members{
  query = {
    for role, members in local.cloudrun_iam_bindings["default"]:
      role => length(lookup(members, "members", []))
  }

  program = ["python", "${path.module}/test_policy_members.py"]
}
output test_policy_members {
  value = data.external.test_policy_members.result
}

//tests traffic block without revision
data external test_traffic{
  query = local.cloudrun_traffic["default"] == [] ? {} : {
    for key, value in element(local.cloudrun_traffic["default"], 0) :
      tostring(key) => tostring(value)
  }
  program = ["python", "${path.module}/test_traffic.py"]
}

output test_traffic {
  value = data.external.test_traffic.result
}

//tests traffic block with revision
data external test_traffic_with_revision{
  query = local.cloudrun_traffic["default"] == [] ? {} : {
    for key, value in element(local.cloudrun_traffic["default"], 1) :
      tostring(key) => tostring(value)
    }
  program = ["python", "${path.module}/test_traffic_with_revision.py"]
}

output test_traffic_config {
  value = data.external.test_traffic_with_revision.result
}

//tests traffic block with no settings, run `terraform apply -var 'gcp_cloudrun_yml=resrouces/empty_traffic.yml'
//data external test_traffic_empty{
//  query = local.cloudrun_traffic["default"] == [] ? {} : {"format" = "not empty list"}
//  program = ["python", "${path.module}/test_traffic_empty.py"]
//}
//
//output test_traffic_empty {
//  value = data.external.test_traffic_empty.result
//}




