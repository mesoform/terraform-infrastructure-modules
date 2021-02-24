
//noinspection HILUnresolvedReference
data "google_project" "self" {
  count = local.gae == {} || lookup(local.gae, "create_google_project", false) ? 0 : 1

  project_id = lookup(local.gae, "project_id", null)
}


//noinspection HILUnresolvedReference
data "google_organization" "self" {
  count = lookup(local.gae, "organization_name", null) != null ? 1 : 0

  domain = lookup(local.gae, "organization_name", null)
}


//noinspection HILUnresolvedReference
resource "google_project" "self" {
  count = lookup(local.gae, "create_google_project", false) ? 1 : 0

  name = lookup(local.gae, "project_name", local.gae.project_id)
  project_id = lookup(local.gae, "project_id", null)
  billing_account = lookup(local.gae, "billing_account", null)
  org_id = lookup(local.gae, "organization_name", null) == null ? null : data.google_organization.self.0.org_id
  folder_id = lookup(local.gae, "folder_id", null) == null ? null : local.gae.folder_id
  labels = merge(lookup(local.project, "labels", {}), lookup(local.gae, "project_labels", {}))
  auto_create_network = lookup(local.gae, "auto_create_network", true)
}


resource "google_project_service" "flex" {
  count = length(local.as_flex_specs) > 0 ? 1 : 0

  project = lookup(local.gae, "create_google_project", false) ? google_project.self.0.project_id : data.google_project.self.0.project_id
  service = "appengineflex.googleapis.com"
  disable_dependent_services = false
}


resource "google_project_service" "std" {
  count = length(local.as_std_specs) > 0 ? 1 : 0

  project = lookup(local.gae, "create_google_project", false) ? google_project.self.0.project_id : data.google_project.self.0.project_id
  service = "appengine.googleapis.com"
  disable_dependent_services = false
}


//noinspection HILUnresolvedReference
resource "google_app_engine_application" "self" {
  count = local.gae == {} ? 0 : 1
  project = length(local.as_flex_specs) > 0 ? google_project_iam_member.gae_api.0.project : google_project_service.std.0.project
  location_id = lookup(local.gae, "location_id", null)
  auth_domain = lookup(local.gae, "auth_domain", null)
  serving_status = lookup(local.gae, "serving_status", null)

  //noinspection HILUnresolvedReference
  dynamic "iap" {
    for_each = lookup(local.gae, "iap", null) == null ? [] : [1]

    //noinspection HILUnresolvedReference
    content {
      enabled = true
      oauth2_client_id = lookup(local.gae.iap, "oauth2_client_id", null)
      oauth2_client_secret = lookup(local.gae.iap, "oauth2_client_secret", null)
    }
  }

  //noinspection HILUnresolvedReference
  dynamic "feature_settings" {
    for_each = lookup(local.gae, "feature_settings", null) == null ? [] : [1]

    //noinspection HILUnresolvedReference
    content {
      split_health_checks = lookup(local.gae.feature_settings, "split_health_checks", null)
    }
  }
}


resource "time_sleep" "flex_sa_propagation" {
  count = length(local.as_flex_specs) > 0 ? 1: 0
  create_duration = lookup(local.gae, "flex_delay", "30s")
  triggers ={
    project_id = google_project_iam_member.gae_api.0.project
  }
}

resource "google_project_iam_member" "gae_api" {
  count = length(local.as_flex_specs) > 0 ? 1 : 0
  # force dependency on the APIs being enabled
  project = google_project_service.flex.0.project
  role = "roles/compute.networkUser"
  //noinspection HILUnresolvedReference
  member = "serviceAccount:service-${lookup(local.gae, "create_google_project", false) ? google_project.self.0.number : data.google_project.self.0.number}@gae-api-prod.google.com.iam.gserviceaccount.com"
}


//noinspection HILUnresolvedReference
resource "google_app_engine_flexible_app_version" "self" {
  for_each = local.as_flex_specs
  # force dependency on the required service account being created and given permission to operate

  project = time_sleep.flex_sa_propagation.0.triggers["project_id"]
  version_id = lookup(each.value, "version_id", lookup(local.project, "version", "v1"))
  service = lookup(each.value, "service", each.key)
  runtime = lookup(each.value, "runtime", null)
  default_expiration = lookup(each.value, "default_expiration", null)
  inbound_services = lookup(each.value, "inbound_services", null)
  instance_class = lookup(each.value, "instance_class", null)
  nobuild_files_regex = lookup(each.value, "nobuild_files_regex", null)
  runtime_api_version = lookup(each.value, "runtime_api_version", null)
  runtime_channel = lookup(each.value, "runtime_channel", null)
  runtime_main_executable_path = lookup(each.value, "runtime_main_executable_path", null)
  serving_status = lookup(each.value, "serving_status", null)
  env_variables = local.env_variables[each.key]

  //noinspection HILUnresolvedReference
  dynamic "deployment" {
    for_each = lookup(each.value, "deployment", null) == null ? {deployment: {zip: {}}} : {deployment: each.value.deployment}

    content {
      //noinspection HILUnresolvedReference
      dynamic "cloud_build_options" {
        for_each = lookup(deployment.value, "cloud_build_options", null) == null ? {} : {cloud_build_options: deployment.value.cloud_build_options}

        content {
          app_yaml_path = lookup(cloud_build_options.value, "app_yaml_path", null)
          cloud_build_timeout = lookup(cloud_build_options.value, "cloud_build_timeout", null)
        }
      }

      //noinspection HILUnresolvedReference
      dynamic "container" {
        for_each = lookup(deployment.value, "container", null) == null ? {} : {container: deployment.value.container}

        content {
          image = lookup(container.value, "image", null)
        }
      }

      dynamic "files" {
        for_each = lookup(local.src_files, each.key, {})
        content {
          name = files.key
          source_url = files.value
        }
      }
    }
  }

  //noinspection HILUnresolvedReference
  dynamic "endpoints_api_service" {
    for_each = lookup(each.value, "endpoints_api_service", null) == null ? {} : {endpoints_api_service: each.value.endpoints_api_service}

    content {
      name = lookup(endpoints_api_service.value, "name", null)
      config_id = lookup(endpoints_api_service.value, "config_id", null)
      disable_trace_sampling = lookup(endpoints_api_service.value, "disable_trace_sampling", null)
      rollout_strategy = lookup(endpoints_api_service.value, "rollout_strategy", null)
    }
  }

  //noinspection HILUnresolvedReference
  dynamic "entrypoint" {
    for_each = lookup(each.value, "entrypoint", null) == null ? {} : {entrypoint: {shell: each.value.entrypoint}}

    content {
      shell = lookup(entrypoint.value, "shell", null)
    }
  }

  //noinspection HILUnresolvedReference
  dynamic "automatic_scaling" {
    # Only one of automatic_scaling or manual_scaling are allowed
    for_each = lookup(each.value, "automatic_scaling", null) == null ? {} : {automatic_scaling: each.value.automatic_scaling}

    content {
      cool_down_period = lookup(automatic_scaling.value, "cool_down_period", null)
      max_concurrent_requests = lookup(automatic_scaling.value, "max_concurrent_requests", null)
      max_idle_instances = lookup(automatic_scaling.value, "max_idle_instances", null)
      max_pending_latency = lookup(automatic_scaling.value, "max_pending_latency", null)
      max_total_instances = lookup(automatic_scaling.value, "max_total_instances", null)
      min_idle_instances = lookup(automatic_scaling.value, "min_idle_instances", null)
      min_pending_latency = lookup(automatic_scaling.value, "min_pending_latency", null)
      min_total_instances = lookup(automatic_scaling.value, "min_total_instances", null)
      //noinspection HILUnresolvedReference
      dynamic "cpu_utilization"{
        for_each = lookup(automatic_scaling.value, "cpu_utilization", null) == null ? {cpu_utilization: {target_utilization: local.default.automatic_scaling.target_utilization}} : {cpu_utilization: automatic_scaling.value.cpu_utilization}
        //noinspection HILUnresolvedReference
        content {
          target_utilization        = lookup(cpu_utilization.value, "target_utilization",local.default.automatic_scaling.target_utilization)
          aggregation_window_length = lookup(cpu_utilization.value, "aggregation_window_length", null )
        }
      }

      //noinspection HILUnresolvedReference
      dynamic "disk_utilization" {
        for_each = lookup(automatic_scaling.value, "disk_utilization", null) == null ? {} : {disk_utilization: automatic_scaling.value.disk_utilization}

        content {
          target_read_bytes_per_second = lookup(disk_utilization.value, "target_read_bytes_per_second", null)
          target_read_ops_per_second = lookup(disk_utilization.value, "target_read_ops_per_second", null)
          target_write_bytes_per_second = lookup(disk_utilization.value, "target_write_bytes_per_second", null)
          target_write_ops_per_second = lookup(disk_utilization.value, "target_write_ops_per_second", null)
        }
      }

      //noinspection HILUnresolvedReference
      dynamic "network_utilization" {
        for_each = lookup(automatic_scaling.value, "network_utilization", null) == null ? {} : {network_utilization: automatic_scaling.value.network_utilization}

        content {
          target_received_bytes_per_second = lookup(network_utilization.value, "target_received_bytes_per_second", null)
          target_received_packets_per_second = lookup(network_utilization.value, "target_received_packets_per_second", null)
          target_sent_bytes_per_second = lookup(network_utilization.value, "target_sent_bytes_per_second", null)
          target_sent_packets_per_second = lookup(network_utilization.value, "target_sent_packets_per_second", null)
        }
      }

      //noinspection HILUnresolvedReference
      dynamic "request_utilization" {
        for_each = lookup(automatic_scaling.value, "request_utilization", null) == null ? {} : {request_utilization: automatic_scaling.value.request_utilization}

        content {
          target_concurrent_requests = lookup(request_utilization.value, "target_concurrent_requests", null)
          target_request_count_per_second = lookup(request_utilization.value, "target_request_count_per_second", null)
        }
      }
    }
  }

  //noinspection HILUnresolvedReference
  dynamic "manual_scaling" {
    # Only one of automatic_scaling or manual_scaling are allowed
    for_each = lookup(each.value, "manual_scaling", null) == null ? {} : {manual_scaling: each.value.manual_scaling}

    content {
      instances = lookup(manual_scaling.value, "instances", 1)
    }
  }

  //noinspection HILUnresolvedReference
  dynamic "network" {
    for_each = lookup(each.value, "network", null) == null ? {} : {network: each.value.network}

    content {
      name = lookup(network.value, "name", null)
      forwarded_ports = lookup(network.value, "forwarded_ports", null)
      instance_tag = lookup(network.value, "instance_tag", null)
      session_affinity = lookup(network.value, "session_affinity", null)
      subnetwork = lookup(network.value, "subnetwork", null)
    }
  }

  //noinspection HILUnresolvedReference
  dynamic "api_config" {
    for_each = lookup(each.value, "api_config", null) == null ? {} : {api_config: each.value.api_config}

    content {
      script = lookup(api_config.value, "script", null)
      auth_fail_action = lookup(api_config.value, "auth_fail_action", null)
      login = lookup(api_config.value, "login", null)
      security_level = lookup(api_config.value, "security_level", null)
      url = lookup(api_config.value, "url", null)
    }
  }

  //noinspection HILUnresolvedReference
  dynamic "liveness_check" {
    # liveness_check is required and path = / is the default
    for_each = lookup(each.value, "liveness_check", null) == null ? {liveness_check: {path: local.default.liveness_check.path}} : {liveness_check: each.value.liveness_check}  # required default. Also see attribute below

    content {
      path = lookup(liveness_check.value, "path", local.default.liveness_check.path)
      check_interval = lookup(liveness_check.value, "check_interval", null)
      failure_threshold = lookup(liveness_check.value, "failure_threshold", null)
      host = lookup(liveness_check.value, "host", null)
      initial_delay = lookup(liveness_check.value, "initial_delay", null)
      success_threshold = lookup(liveness_check.value, "success_threshold", null)
      timeout = lookup(liveness_check.value, "timeout", null)
    }
  }

  //noinspection HILUnresolvedReference
  dynamic "readiness_check" {
    # readiness_check is required and path = / is the default
    for_each = lookup(each.value, "readiness_check", null) == null ? {readiness_check: {path: local.default.readiness_check.path}} : {readiness_check: each.value.readiness_check}  # required default. Also see attribute below

    content {
      path = lookup(readiness_check.value, "path", local.default.readiness_check.path)
      app_start_timeout = lookup(readiness_check.value, "app_start_timeout", null)
      check_interval = lookup(readiness_check.value, "check_interval", null)
      failure_threshold = lookup(readiness_check.value, "failure_threshold", null)
      host = lookup(readiness_check.value, "host", null)
      success_threshold = lookup(readiness_check.value, "success_threshold", null)
      timeout = lookup(readiness_check.value, "timeout", null)
    }
  }

  //noinspection HILUnresolvedReference
  dynamic "resources" {
    for_each = lookup(each.value, "resources", null) == null ? {} : {resources: each.value.resources}

    content {
      cpu = lookup(resources.value, "cpu", null)
      disk_gb = lookup(resources.value, "disk_gb", null)
      memory_gb = lookup(resources.value, "memory_gb", null)

      //noinspection HILUnresolvedReference
      dynamic "volumes" {
        for_each = lookup(resources.value, "volumes", null) == null ? {} : {volumes: resources.value.volumes}

        content {
          name = lookup(volumes.value, "name", null)
          size_gb = lookup(volumes.value, "size_gb", null)
          volume_type = lookup(volumes.value, "volume_type", null)
        }
      }
    }
  }

  //noinspection HILUnresolvedReference
  dynamic "vpc_access_connector" {
    for_each = lookup(each.value, "vpc_access_connector", null) == null ? {} : {vpc_access_connector: each.value.vpc_access_connector}

    content {
      name = lookup(vpc_access_connector.value, "name", null)
    }
  }

  # Terraform in-built properties
  noop_on_destroy = var.tf_noop_on_destroy
  delete_service_on_destroy = var.tf_delete_service_on_destroy
  lifecycle {
    create_before_destroy = true
  }
}


//noinspection HILUnresolvedReference
resource "google_app_engine_standard_app_version" "self" {
  for_each = local.as_std_specs

  project = google_project_service.std.0.project
  version_id = lookup(each.value, "version_id", lookup(local.project, "version", "v1"))
  service = lookup(each.value, "service", each.key)
  runtime = lookup(each.value, "runtime", null)
  instance_class = lookup(each.value, "instance_class", null)
  runtime_api_version = lookup(each.value, "runtime_api_version", null)
  threadsafe = lookup(each.value, "threadsafe", null)
  env_variables = local.env_variables[each.key]

  //noinspection HILUnresolvedReference
  dynamic "deployment" {
    for_each = lookup(each.value, "deployment", null) == null ? {deployment: {zip: {}}} : {deployment: each.value.deployment}

    content {
      dynamic "files" {
        for_each = lookup(local.src_files, each.key, {})
        content {
          name = files.key
          source_url = files.value
        }
      }
    }
  }

  //noinspection HILUnresolvedReference
  dynamic "entrypoint" {
    for_each = lookup(each.value, "entrypoint", null) == null ? {} : {entrypoint: {shell: each.value.entrypoint}}

    content {
      shell = lookup(entrypoint.value, "shell", null)
    }
  }

  //noinspection HILUnresolvedReference
  dynamic "handlers" {
    # Handlers is an array of maps
    for_each = lookup(each.value, "handlers", [])

    content {
      auth_fail_action = lookup(handlers.value, "auth_fail_action", null)
      login = lookup(handlers.value, "login", null)
      redirect_http_response_code = lookup(handlers.value, "redirect_http_response_code", null)
      security_level = lookup(handlers.value, "security_level", null)
      url_regex = lookup(handlers.value, "url_regex", null)

      //noinspection HILUnresolvedReference
      dynamic "script" {
        for_each = lookup(handlers.value, "script", null) == null ? {} : {script_path: handlers.value.script}

        content {
          script_path = lookup(script.value, "script_path", null)
        }
      }

      //noinspection HILUnresolvedReference
      dynamic "static_files" {
        for_each = lookup(handlers.value, "static_files", null) == null ? {} : {static_files: handlers.value.static_files}

        content {
          application_readable = lookup(static_files.value, "application_readable", null)
          expiration = lookup(static_files.value, "expiration", null)
          mime_type = lookup(static_files.value, "mime_type", null)
          path = lookup(static_files.value, "path", null)
          require_matching_file = lookup(static_files.value, "require_matching_file", null)
          upload_path_regex = lookup(static_files.value, "upload_path_regex", null)
          http_headers = lookup(static_files.value, "http_headers", {})
        }
      }
    }
  }

  //noinspection HILUnresolvedReference,ConflictingProperties
  dynamic "basic_scaling" {
    # Only one of automatic_scaling, basic_scaling or manual_scaling are allowed so check for the other here
    for_each = lookup(each.value, "basic_scaling", null) == null ? {} : {basic_scaling: each.value.basic_scaling}

    content {
      max_instances = lookup(basic_scaling.value, "max_instances", null)
    }
  }

  //noinspection HILUnresolvedReference,ConflictingProperties
  dynamic "automatic_scaling" {
    # Only one of automatic_scaling, basic_scaling or manual_scaling are allowed so check for the other here
    for_each = lookup(each.value, "automatic_scaling", null) == null ? {} : {automatic_scaling: each.value.automatic_scaling}

    content {
      max_concurrent_requests = lookup(automatic_scaling.value, "max_concurrent_requests", null)
      max_idle_instances = lookup(automatic_scaling.value, "max_idle_instances", null)
      max_pending_latency = lookup(automatic_scaling.value, "max_pending_latency", null)
      min_idle_instances = lookup(automatic_scaling.value, "min_idle_instances", null)
      min_pending_latency = lookup(automatic_scaling.value, "min_pending_latency", null)

      //noinspection HILUnresolvedReference
      dynamic "standard_scheduler_settings" {
        for_each = lookup(automatic_scaling.value, "standard_scheduler_settings", null) == null ? {} : {standard_scheduler_settings: automatic_scaling.value.standard_scheduler_settings}

        content {
          max_instances = lookup(standard_scheduler_settings.value, "max_instances", null)
          min_instances = lookup(standard_scheduler_settings.value, "min_instances", null)
          target_cpu_utilization = lookup(standard_scheduler_settings.value, "target_cpu_utilization", null)
          target_throughput_utilization = lookup(standard_scheduler_settings.value, "target_throughput_utilization", null)
        }
      }
    }
  }

  //noinspection HILUnresolvedReference,ConflictingProperties
  dynamic "manual_scaling" {
    # Only one of automatic_scaling, basic_scaling or manual_scaling are allowed so check for the other here
    for_each = lookup(each.value, "manual_scaling", null) == null ? {} : {manual_scaling: each.value.manual_scaling}

    content {
      instances = lookup(manual_scaling.value, "instances", null)
    }
  }


  # Terraform in-built properties
  noop_on_destroy = var.tf_noop_on_destroy
  delete_service_on_destroy = var.tf_delete_service_on_destroy
  lifecycle {
    create_before_destroy = true
  }
}

resource "google_app_engine_service_split_traffic" "std-split" {
  for_each = local.gae_traffic_std
  depends_on = [google_app_engine_standard_app_version.self]
  project = google_app_engine_application.self.0.project
  migrate_traffic = lookup(local.as_std_specs[each.key], "migrate_traffic", false)
  service = each.key
  split {
    shard_by = lookup(local.as_std_specs[each.key], "shard_by", "IP")
    allocations = each.value
  }
}


resource "google_app_engine_service_split_traffic" "flex-split"{
  for_each = local.gae_traffic_flex
  depends_on = [google_app_engine_flexible_app_version.self]
  project = google_app_engine_application.self.0.project
  service = each.key
  migrate_traffic = false
  split {
    shard_by = lookup(local.as_flex_specs[each.key], "shard_by", "IP")
    allocations = each.value
  }

}