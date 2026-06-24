terraform {
  experiments = [module_variable_optional_attrs]
}

//noinspection HILUnresolvedReference
data external test_blue_instance_template{
  query = {"security_level" = local.blue_instance_template.security_level}
  program = ["python", "${path.module}/test_blue_instance_template.py"]
}

output test_blue_instance_template {
  value = data.external.test_blue_instance_template.result
}

//noinspection HILUnresolvedReference
data external test_green_instance_template{
  query = {"security_level" = local.green_instance_template.security_level}
  program = ["python", "${path.module}/test_green_instance_template.py"]
}

output test_green_instance_template {
  value = data.external.test_green_instance_template.result
}

//noinspection HILUnresolvedReference
data external test_stateful_boot_disk_config {
  query = {"device_name" = local.stateful_boot_disk.0.device_name}
  program = ["python", "${path.module}/test_stateful_boot_disk_config.py"]
}

output test_stateful_boot_disk_config {
  value = data.external.test_stateful_boot_disk_config.result
}