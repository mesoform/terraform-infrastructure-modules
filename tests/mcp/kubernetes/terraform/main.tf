data external test_map_config{
//  query = {
//    for key, value in local.k8s_services:
//        key => keys(value)[0]
//  }
  query = local.k8s_services
  program = ["python", "${path.module}/test_map_config.py"]
}

output test_map_config{
  value = data.external.test_map_config.result
}
