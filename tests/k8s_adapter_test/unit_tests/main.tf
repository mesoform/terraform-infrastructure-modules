data external test_kubernetes_deployment {
  //query   = lookup(local.k8s_deployments.mosquitto.deployment.metadata, "labels", {})
  query   = lookup(local.k8s_deployments.mosquitto.deployment.spec.selector, "match_labels", {})
  program = ["/usr/local/bin/python3", "${path.module}/test_deployment.py"]
}
output test_deployment {
  value = data.external.test_kubernetes_deployment.result
}

data external test_pod {
  query   = lookup(local.k8s_pods.nginx_pod.pod.spec, "env", {})
  program = ["/usr/local/bin/python3", "${path.module}/test_pod.py"]
}
output test_pod {
  value = data.external.test_pod.result
}

data external test_ingress {
  query   = lookup(local.k8s_ingress.Ingress.ingress.spec, "backend", {})
  program = ["/usr/local/bin/python3", "${path.module}/test_ingress.py"]
}
output test_ingress {
  value = data.external.test_ingress.result
}

data external test_pod_autoscaler {
  query   = lookup(local.k8s_pod_autoscaler.pod_autoscaler_app.pod_autoscaler.spec, "scale_target_ref", {})
  program = ["/usr/local/bin/python3", "${path.module}/test_pod_autoscaler.py"]
}
output test_pod_autoscaler {
  value = data.external.test_pod_autoscaler.result
}

data external test_service {
  query   = lookup(local.k8s_services.mosquitto.service.spec, "selector", {})
  program = ["/usr/local/bin/python3", "${path.module}/test_service.py"]
}
output test_service {
  value = data.external.test_service.result
}

data external test_secret {
  query   = local.k8s_secret_data.mosquitto
  program = ["/usr/local/bin/python3", "${path.module}/test_secret.py"]
}
output test_secret {
  value = data.external.test_secret.result
}

data external test_config_map {
  query   = local.k8s_config_map_data.mosquitto
  program = ["/usr/local/bin/python3", "${path.module}/test_config_map.py"]
}
output test_config_map {
  value = data.external.test_config_map.result
}
