locals {
  k8s_config_map = { for app, kube_file in var.k8s_config_map_yml :
    app => { config_map : yamldecode(file(kube_file)) }
    if fileexists(kube_file)
  }

  k8s_config_map_data = { for app_name, config in local.k8s_config_map :
    app_name => merge({

      for name, content in lookup(local.k8s_config_map[app_name].config_map, "data", {}) :
      name => content
      }, {
      for file in lookup(local.k8s_config_map[app_name].config_map, "data_file", {}) :
      basename(file) => file(file)
    })
  }

  k8s_config_map_binary_data = { for app_name, config in local.k8s_config_map :
    app_name => merge({
      for name, content in lookup(local.k8s_config_map[app_name].config_map, "binary_data", {}) :
      name => content
      }, {
      for file in lookup(local.k8s_config_map[app_name].config_map, "binary_file", {}) :
      basename(file) => filebase64(file)
    })
  }

  k8s_deployments = { for app, kube_file in var.k8s_deployment_yml :
    app => { deployment : yamldecode(file(kube_file)) }
    if fileexists(kube_file)
  }

  k8s_secret = { for app, kube_file in var.k8s_secret_files_yml :
    app => { secret : yamldecode(file(kube_file)) }
    if fileexists(kube_file)
  }

  k8s_secret_data = { for app_name, config in local.k8s_secret :
    app_name => merge({
      for name, content in lookup(local.k8s_secret[app_name].secret, "data", {}) :
      name => content
      }, {
      for file in lookup(local.k8s_secret[app_name].secret, "data_file", {}) :
      basename(file) => file(file)
    })
  }

  k8s_services = { for app, kube_file in var.k8s_service_yml :
    app => { service : yamldecode(file(kube_file)) }
    if fileexists(kube_file)
  }

  k8s_pods = { for app, kube_file in var.k8s_pod_yml :
    app => { pod : yamldecode(file(kube_file)) }
    if fileexists(kube_file)
  }

  k8s_ingress = { for app, kube_file in var.k8s_ingress_yml :
    app => { ingress : yamldecode(file(kube_file)) }
    if fileexists(kube_file)
  }

  k8s_service_account = { for app, kube_file in var.k8s_service_account_yml :
    app => { service_account : yamldecode(file(kube_file)) }
    if fileexists(kube_file)
  }

  k8s_job = { for app, kube_file in var.k8s_job_yml :
    app => { job : yamldecode(file(kube_file)) }
    if fileexists(kube_file)
  }

  k8s_cron_job = { for app, kube_file in var.k8s_cron_job_yml :
    app => { cron_job : yamldecode(file(kube_file)) }
    if fileexists(kube_file)
  }

  k8s_pod_autoscaler = { for app, kube_file in var.k8s_pod_autoscaler_yml :
    app => { pod_autoscaler : yamldecode(file(kube_file)) }
    if fileexists(kube_file)
  }

  k8s_persistent_volume = { for app, kube_file in var.k8s_persistent_volume_yml :
    app => { persistent_volume : yamldecode(file(kube_file)) }
    if fileexists(kube_file)
  }

  k8s_persistent_volume_claim = { for app, kube_file in var.k8s_persistent_volume_claim_yml :
    app => { persistent_volume_claim : yamldecode(file(kube_file)) }
    if fileexists(kube_file)
  }

}
