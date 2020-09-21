//noinspection HILUnresolvedReference

data external test_iam_members{
  query = local.cloudrun_iam.members
  program = ["python", "${path.module}/test_iam_members.py"]
}
output test_iam_members {
  value = data.external.test_iam_members.result
}
//
//data external test_traffic_config{
//  query = #todo config data into json format
//  program = ["python", "${path.module}/test_traffic_config.py"]
//}
//output test_traffic_config {
//  value = data.external.test_traffic_config.result
//}
