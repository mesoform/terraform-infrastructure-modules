data external test_docker_config {
  query   = lookup(local.k8s_deployments.mosquitto.deployment.spec.selector, "match_labels", {})
  program = ["/usr/local/bin/python3", "${path.module}/test_deployment.py"]
}
output docker_config {
  value = data.external.test_docker_config.result
}

data external docker_container {
  query   = lookup(local.k8s_pods.nginx_pod.pod.spec, "env", {})
  program = ["/usr/local/bin/python3", "${path.module}/test_pod.py"]
}
output docker_container {
  value = data.external.docker_container.result
}

data external docker_image {
  query   = lookup(local.k8s_ingress.Ingress.ingress.spec, "backend", {})
  program = ["/usr/local/bin/python3", "${path.module}/test_ingress.py"]
}
output docker_image {
  value = data.external.docker_image.result
}

data external docker_network {
  query   = lookup(local.k8s_pod_autoscaler.pod_autoscaler_app.pod_autoscaler.spec, "scale_target_ref", {})
  program = ["/usr/local/bin/python3", "${path.module}/test_pod_autoscaler.py"]
}
output docker_network {
  value = data.external.docker_network.result
}

data external docker_plugin {
  query   = lookup(local.k8s_services.mosquitto.service.spec, "selector", {})
  program = ["/usr/local/bin/python3", "${path.module}/test_service.py"]
}
output docker_plugin {
  value = data.external.docker_plugin.result
}

data external docker_registry_image {
  query   = local.k8s_secret_data.mosquitto
  program = ["/usr/local/bin/python3", "${path.module}/test_secret.py"]
}
output docker_registry_image {
  value = data.external.docker_registry_image.result
}

data external docker_secret {
  query   = local.k8s_config_map_data.mosquitto
  program = ["/usr/local/bin/python3", "${path.module}/test_config_map.py"]
}
output docker_secret {
  value = data.external.docker_secret.result
}

data external docker_service {
  query   = local.k8s_config_map_data.mosquitto
  program = ["/usr/local/bin/python3", "${path.module}/test_config_map.py"]
}
output docker_service {
  value = data.external.docker_service.result
}

data external docker_volume {
  query   = local.k8s_config_map_data.mosquitto
  program = ["/usr/local/bin/python3", "${path.module}/test_config_map.py"]
}
output docker_volume {
  value = data.external.docker_volume.result
}
