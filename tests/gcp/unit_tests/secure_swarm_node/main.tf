data external test_blue_instance_template{
  query = {"security_level" = local.blue_instance_template.security_level}
  program = ["python", "${path.module}/test_blue_instance_template.py"]
}

output test_blue_instance_template {
  value = data.external.test_blue_instance_template.result
}

data external test_green_instance_template{
  query = {"security_level" = local.blue_instance_template.security_level}
  program = ["python", "${path.module}/test_blue_instance_template.py"]
}

output test_green_instance_template {
  value = data.external.test_green_instance_template.result
}