locals {
  k8s = {
    for app, config in local.k8s_services :
    app => merge(config, lookup(local.k8s_deployments, app, {}))
  }
  k8s_config_map_files = fileset(path.root, "../**/k8s_config_map.y{a,}ml")
  k8s_config_map = {
    for kube_file in local.k8s_config_map_files :
    basename(dirname(kube_file)) => { config_map : yamldecode(file(kube_file)) }
    if ! contains(split("/", kube_file), "terraform")
  }

  k8s_config_map_data = { for app_name, config in local.k8s_config_map :
    app_name => merge({
      for data_key, data_value in lookup(local.k8s_config_map[app_name].config_map, "data", {}) :
      data_key => data_value
      }, {
      for file in lookup(local.k8s_config_map[app_name].config_map, "data_file", {}) :
      basename(file) => file(file)
    })
  }

  k8s_config_map_binary_data = { for app_name, config in local.k8s_config_map :
    app_name => {
      for file in lookup(local.k8s_config_map[app_name].config_map, "binary_file", {}) :
      basename(file) => filebase64(file)
    }
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

  k8s_secret_data = { for app_name, config in local.k8s_secret :
    app_name => merge({
      for data_key, data_value in lookup(local.k8s_secret[app_name].secret, "data", {}) :
      data_key => data_value
      }, {
      for file in lookup(local.k8s_secret[app_name].secret, "data_file", {}) :
      basename(file) => file(file)
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
    basename(dirname(kube_file)) => { ingress : yamldecode(file(kube_file)) }
    if ! contains(split("/", kube_file), "terraform")
  }

  k8s_service_account_files = fileset(path.root, "../**/k8s_service_account.y{a,}ml")
  k8s_service_account = {
    for kube_file in local.k8s_service_account_files :
    basename(dirname(kube_file)) => { service_account : yamldecode(file(kube_file)) }
    if ! contains(split("/", kube_file), "terraform")
  }

  k8s_job_files = fileset(path.root, "../**/k8s_job.y{a,}ml")
  k8s_job = {
    for kube_file in local.k8s_job_files :
    basename(dirname(kube_file)) => { job : yamldecode(file(kube_file)) }
    if ! contains(split("/", kube_file), "terraform")
  }

  k8s_cron_job_files = fileset(path.root, "../**/k8s_cron_job.y{a,}ml")
  k8s_cron_job = {
    for kube_file in local.k8s_cron_job_files :
    basename(dirname(kube_file)) => { cron_job : yamldecode(file(kube_file)) }
    if ! contains(split("/", kube_file), "terraform")
  }

  k8s_pod_autoscaler_files = fileset(path.root, "../**/k8s_pod_autoscaler.y{a,}ml")
  k8s_pod_autoscaler = {
    for kube_file in local.k8s_pod_autoscaler_files :
    basename(dirname(kube_file)) => { pod_autoscaler : yamldecode(file(kube_file)) }
    if ! contains(split("/", kube_file), "terraform")
  }
}
