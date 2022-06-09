
data external test_docker_config {
  query   = local.docker_config["specs"].docker_config
  program = ["python", "${path.module}/test_docker_config.py"]
}
output docker_config {
  value = data.external.test_docker_config.result
}

data external docker_container {
  query   = local.docker_container["specs"].docker_container
  program = ["python", "${path.module}/test_docker_container.py"]
}
output docker_container {
  value = data.external.docker_container.result
}

data external docker_image {
  query   = lookup(local.docker_image["specs"].docker_image.build, "build_arg", {})
  program = ["python", "${path.module}/test_docker_image.py"]
}
output docker_image {
  value = data.external.docker_image.result
}

data external docker_network {
  query   = local.docker_network["specs"].docker_network
  program = ["python", "${path.module}/test_docker_network.py"]
}
output docker_network {
  value = data.external.docker_network.result
}

data external docker_plugin {
  query   = lookup(local.docker_plugin["specs"], "docker_plugin", {})
  program = ["python", "${path.module}/test_docker_plugin.py"]
}
output docker_plugin {
  value = data.external.docker_plugin.result
}

data external docker_registry_image {
  query   = local.docker_registry_image["specs"].docker_registry_image.build
  program = ["python", "${path.module}/test_docker_registry_image.py"]
}
output docker_registry_image {
  value = data.external.docker_registry_image.result
}

data external docker_secret {
  query   = local.docker_secret["specs"].docker_secret
  program = ["python", "${path.module}/test_docker_secret.py"]
}

output docker_secret {
  value = data.external.docker_secret.result
}

data external docker_service {
  query   = lookup(local.docker_service["specs"].docker_service.endpoint_spec, "ports", {})
  program = ["python", "${path.module}/test_docker_service.py"]
}
output docker_service {
  value = data.external.docker_service.result
}

data external docker_volume {
  query   = local.docker_volume["specs"].docker_volume
  program = ["python", "${path.module}/test_docker_volume.py"]
}
output docker_volume {
  value = data.external.docker_volume.result
}
