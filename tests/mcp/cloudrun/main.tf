//noinspection HILUnresolvedReference

data external test_iam_members{
  query = local.cloudrun_iam.members
  program = ["python", "${path.module}/test_iam_members.py"]
}
output test_iam_members {
  value = data.external.test_iam_members.result
}

//tests traffic block without revision,
data external test_traffic{
  query = {for key, value in element(local.cloudrun_traffic, 0) : tostring(key) => tostring(value)}
  program = ["python", "${path.module}/test_traffic.py"]
}

output test_traffic {
  value = data.external.test_traffic.result
}

//tests traffic block with revision,
data external test_traffic_with_revision{
  query = {for key, value in element(local.cloudrun_traffic, 1) : tostring(key) => tostring(value)}
  program = ["python", "${path.module}/test_traffic_with_revision.py"]
}

output test_traffic_config {
  value = data.external.test_traffic_with_revision.result
}


