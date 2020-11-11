locals {

  kubernetes_config_yml = fileexists(var.k8s_yml) ? file(var.k8s_yml) : null

  kubernetes = local.kubernetes_config_yml == null ? {} : yamldecode(local.kubernetes_config_yml)

  k8s_components       = try(lookup(local.kubernetes, "components", {}), lookup(local.kubernetes, "components"))
  k8s_components_specs = lookup(local.k8s_components, "specs", {})


  k8s_config_map = { for app, config in local.k8s_components_specs :
    app => { config_map : lookup(config, "config_map", null) }
    if lookup(config, "config_map", null) != null
  }

  k8s_config_map_data = { for app_name, config in local.k8s_config_map :
    app_name => merge({
      for name, content in lookup(local.k8s_config_map[app_name].config_map, "data", null) :
      name => content
      }, {
      for file in lookup(local.k8s_config_map[app_name].config_map, "data_file", null) :
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

  k8s_deployments = { for app, config in local.k8s_components_specs :
    app => { deployment : lookup(config, "deployment", null) }
    if lookup(config, "deployment", null) != null
  }

  k8s_secret = { for app, config in local.k8s_components_specs :
    app => { secret : lookup(config, "secret", null) }
    if lookup(config, "secret", null) != null
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

  k8s_services = { for app, config in local.k8s_components_specs :
    app => { service : lookup(config, "service", null) }
    if lookup(config, "service", null) != null
  }

  k8s_pods = { for app, config in local.k8s_components_specs :
    app => { pod : lookup(config, "pod", null) }
    if lookup(config, "pod", null) != null
  }

  k8s_ingress = { for app, config in local.k8s_components_specs :
    app => { ingress : lookup(config, "ingress", null) }
    if lookup(config, "ingress", null) != null
  }

  k8s_service_account = { for app, config in local.k8s_components_specs :
    app => { service_account : lookup(config, "service_account", null) }
    if lookup(config, "service_account", null) != null
  }

  k8s_job = { for app, config in local.k8s_components_specs :
    app => { job : lookup(config, "job", null) }
    if lookup(config, "job", null) != null
  }

  k8s_cron_job = { for app, config in local.k8s_components_specs :
    app => { cron_job : lookup(config, "cron_job", null) }
    if lookup(config, "cron_job", null) != null
  }

  k8s_pod_autoscaler = { for app, config in local.k8s_components_specs :
    app => { pod_autoscaler : lookup(config, "pod_autoscaler", null) }
    if lookup(config, "pod_autoscaler", null) != null
  }

  k8s_persistent_volume = { for app, config in local.k8s_components_specs :
    app => { persistent_volume : lookup(config, "persistent_volume", null) }
    if lookup(config, "persistent_volume", null) != null
  }

  k8s_persistent_volume_claim = { for app, config in local.k8s_components_specs :
    app => { persistent_volume_claim : lookup(config, "k8s_persistent_volume_claim", null) }
    if lookup(config, "persistent_volume_claim", null) != null
  }

  k8s_stateful_set = { for app, config in local.k8s_components_specs :
    app => { stateful_set : lookup(config, "stateful_set", null) }
    if lookup(config, "stateful_set", null) != null
  }
}
