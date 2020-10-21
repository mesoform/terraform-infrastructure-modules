data external test_map_config {
  query = {
    for key, value in local.k8s_services :
    key => keys(value)[0]
  }
  program = ["python", "${path.module}/test_map_config.py"]
}

output test_map_config {
  value = data.external.test_map_config.result
}

data external test_config_map_data {
  query   = local.k8s_config_map_data["resources"]
  program = ["python", "${path.module}/test_config_map_data.py"]
}

output test_config_map_data {
  value = data.external.test_config_map_data.result
}

data external test_config_map_binary_data {
  query   = local.k8s_config_map_binary_data["resources"]
  program = ["python", "${path.module}/test_config_map_binary_data.py"]
}

output test_config_map_binary_data {
  value = data.external.test_config_map_binary_data.result
}

data external test_secret_data {
  query   = local.k8s_secret_data["resources"]
  program = ["python", "${path.module}/test_secret_data.py"]
}

output test_secret_data {
  value = data.external.test_secret_data.result
}

data external test_job {
  query   = local.k8s_job["resources"].job.metadata
  program = ["python", "${path.module}/test_job.py"]
}

output test_job {
  value = data.external.test_job.result
}
