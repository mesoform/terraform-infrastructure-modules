locals {
  k8s = {
    for app, config in local.k8s_services:
      app => merge(config, lookup(local.k8s_deployments, app, {}))
  }
  k8s_config_map_files = fileset(path.root, "../**/k8s_config_map.y{a,}ml")
  k8s_config_map = {
    for kube_file in local.k8s_config_map_files :
    basename(dirname(kube_file)) => { config_map : yamldecode(file(kube_file)) }
    if ! contains(split("/", kube_file), "terraform")
  }
  k8s_config_map_data = {for key1, value1 in local.k8s_config_map :
    key1 => merge({
      for key2, value2 in lookup(local.k8s_config_map[key1].config_map, "data", {}) :
        key2 => value2
    },{
        for val in lookup(local.k8s_config_map[key1].config_map, "data_file", {}) :
          basename(val) => file(val)
    })
  }
  k8s_config_map_binary_data = {for key1, value1 in local.k8s_config_map :
    key1 => merge({
      for key2, value2 in lookup(local.k8s_config_map[key1].config_map, "binary_data", {}) :
        key2 => value2
    },{
      for val in lookup(local.k8s_config_map[key1].config_map, "binary_file", {}) :
        basename(val) => filebase64(val)
    })
  }

  k8s_deployments_files = fileset(path.root, "../**/k8s_deployment.y{a,}ml")
  k8s_deployments = {
    for kube_file in local.k8s_deployments_files :
    basename(dirname(kube_file)) => { deployment : yamldecode(file(kube_file)) }
    if ! contains(split("/", kube_file), "terraform")
  }

  k8s_secret_files = fileset(path.root, "../**/k8s_secret.y{a,}ml")
  k8s_secret = {
    for kube_file in local.k8s_secret_files :
    basename(dirname(kube_file)) => { secret : yamldecode(file(kube_file)) }
    if ! contains(split("/", kube_file), "terraform")
  }

  k8s_secret_data = {for key1, value1 in local.k8s_secret :
    key1 => merge({
      for key2, value2 in lookup(local.k8s_secret[key1].secret, "data", {}) :
        key2 => value2
    },{
      for val in lookup(local.k8s_secret[key1].secret, "data_file", {}) :
        basename(val) => file(val)
    })
  }

  k8s_services_files = fileset(path.root, "../**/k8s_service.y{a,}ml")
  k8s_services = {
    for kube_file in local.k8s_services_files :
    basename(dirname(kube_file)) => { service : yamldecode(file(kube_file)) }
    if ! contains(split("/", kube_file), "terraform")
  }

  k8s_pod_files = fileset(path.root, "../**/k8s_pod.y{a,}ml")
  k8s_pods = {
    for kube_file in local.k8s_pod_files :
    basename(dirname(kube_file)) => { pod : yamldecode(file(kube_file)) }
    if ! contains(split("/", kube_file), "terraform")
  }

  k8s_ingress_files = fileset(path.root, "../**/k8s_ingress.y{a,}ml")
  k8s_ingress = {
    for kube_file in local.k8s_ingress_files :
      basename(dirname(kube_file)) => {ingress: yamldecode(file(kube_file))}
        if ! contains(split("/", kube_file), "terraform")
  }
}