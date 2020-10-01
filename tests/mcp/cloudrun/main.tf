//noinspection HILUnresolvedReference

data external test_policy_members{
  query = merge(flatten([
    for role, members in local.cloudrun_iam_bindings["default"] : {
      for member in lookup(members, "members", []):
        member => role
    }
  ])...)

  program = ["python", "${path.module}/test_policy_members.py"]
}
output test_policy_members {
  value = data.external.test_policy_members.result
}

output bindings{
  value = local.cloudrun_iam_bindings["default"]["viewer"]
}

//tests traffic block without revision
data external test_traffic{
  query = {for key, value in element(local.cloudrun_traffic["default"], 0) : tostring(key) => tostring(value)}
  program = ["python", "${path.module}/test_traffic.py"]
}

output test_traffic {
  value = data.external.test_traffic.result
}

//tests traffic block with revision
data external test_traffic_with_revision{
  query = {for key, value in element(local.cloudrun_traffic["default"], 1) : tostring(key) => tostring(value)}
  program = ["python", "${path.module}/test_traffic_with_revision.py"]
}

output test_traffic_config {
  value = data.external.test_traffic_with_revision.result
}


//tests traffic block with no settings, to run this test comment out other traffic blocks and set the
//gcp_cloudrun_yml variable to "resources/empty_traffic.yml" in the command line
data external test_traffic_empty{
  query = local.cloudrun_traffic["default"] == [] ? {} : {"format" = "not empty list"}
  program = ["python", "${path.module}/test_traffic_empty.py"]
}

output test_traffic_empty {
  value = data.external.test_traffic_empty.result
}




