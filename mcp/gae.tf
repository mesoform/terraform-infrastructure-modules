locals {
  gae_files = fileset(path.root, "../**/app.y{a,}ml")
  gae_apps = {
    for app_file in local.gae_files:
      basename(dirname(app_file)) => yamldecode(file(app_file))
      if !contains(split("/", app_file), "terraform") &&
          substr(app_file, 2, 18) != "/build/staged-app/"
  }
  gae_flex_list = {
    for app, config in local.gae_apps:
      app => merge(config, lookup(local.common, app, {}))
      if lookup(config, "env", "standard") == "flex"
  }
  gae_std_list = {
    for app, config in local.gae_apps:
      app => merge(config, lookup(local.common, app, {}))
      if lookup(config, "env", "standard") == "standard"
  }
}

data "google_project" "self" {
  count = var.create_google_project ? 0 : 1
  project_id = var.google_project
}

resource "google_project" "self" {
  count = var.create_google_project ? 1 : 0
  name = var.google_project
  project_id = var.google_project
  org_id = var.google_org_id
  billing_account = var.google_billing_account
}

resource "google_app_engine_application" "self" {
  project = var.create_google_project ? google_project.self.0.id : data.google_project.self.0.id
  location_id = var.google_location
}

resource "google_project_service" "self" {
  project = google_app_engine_application.self.project
  service = "appengineflex.googleapis.com"
  disable_dependent_services = false
}

resource "google_project_iam_member" "self" {
  project = google_project_service.self.project
  role = "roles/compute.networkUser"
  member = "serviceAccount:service-${var.create_google_project ? google_project.self.0.number : data.google_project.self.0.number}@gae-api-prod.google.com.iam.gserviceaccount.com"
}

//noinspection HILUnresolvedReference
resource "google_app_engine_flexible_app_version" "self" {
  for_each = local.gae_flex_list

  project = google_project_iam_member.self.project

  version_id = lookup(each.value, "api_version", null)
  service = lookup(each.value, "service", null)
  runtime = lookup(each.value, "runtime", null)
  default_expiration = lookup(each.value, "default_expiration", null)
  inbound_services = lookup(each.value, "inbound_services", null)
  instance_class = lookup(each.value, "instance_class", null)
  nobuild_files_regex = lookup(each.value, "nobuild_files_regex", null)
  runtime_api_version = lookup(each.value, "runtime_api_version", null)
  runtime_channel = lookup(each.value, "runtime_channel", null)
  runtime_main_executable_path = lookup(each.value, "runtime_main_executable_path", null)
  serving_status = lookup(each.value, "serving_status", null)

  //noinspection HILUnresolvedReference
  dynamic "deployment" {
    for_each = lookup(each.value, "deployment", null) == null ? {} : {deployment: each.value.deployment}
    content {
      //noinspection HILUnresolvedReference
      dynamic "cloud_build_options" {
        for_each = lookup(deployment.value, "cloud_build_options", null) == null ? {} : {cloud_build_options: deployment.value.cloud_build_options}
        content {
          app_yaml_path = lookup(cloud_build_options.value, "app_yaml_path", null)
          cloud_build_timeout = lookup(cloud_build_options.value, "cloud_build_timeout_sec", null)
        }
      }
      //noinspection HILUnresolvedReference
      dynamic "container" {
        for_each = lookup(deployment.value, "container", null) == null ? {} : {container: deployment.value.container}
        content {
          image = lookup(container.value, "image", null)
        }
      }
      //noinspection HILUnresolvedReference
      dynamic "files" {
        for_each = lookup(deployment.value, "files", null) == null ? {} : {files: deployment.value.files}
        content {
          name = lookup(files.value, "name", null)
          source_url = lookup(files.value, "source_url", null)
          sha1_sum = lookup(files.value, "sha1_sum", null)
        }
      }
      //noinspection HILUnresolvedReference
      dynamic "zip" {
        for_each = lookup(deployment.value, "zip", null) == null ? {} : {zip: deployment.value.zip}
        content {
          source_url = lookup(zip.value, "source_url", null)
          files_count = lookup(zip.value, "files_count", null)
        }
      }
    }
  }

  dynamic "endpoints_api_service" {
    for_each = lookup(each.value, "endpoints_api_service", {})
    //noinspection HILUnresolvedReference
    content {
      name = lookup(each.value, "name", null)
      config_id = lookup(each.value, "config_id", null)
      disable_trace_sampling = lookup(each.value, "disable_trace_sampling", null)
      rollout_strategy = lookup(each.value, "rollout_strategy", null)
    }
  }

  dynamic "entrypoint" {
    for_each = lookup(each.value, "entrypoint", {})
    //noinspection HILUnresolvedReference
    content {
      shell = lookup(each.value, "shell", null)
    }
  }

  dynamic "automatic_scaling" {
    for_each = lookup(each.value, "manual_scaling", null) != null ? {} : lookup(each.value, "automatic_scaling", {cpu_utilization: {}})  # required default. Also see attribute below
    //noinspection HILUnresolvedReference
    content {
      cool_down_period = lookup(each.value, "cool_down_period", null)
      max_concurrent_requests = lookup(each.value, "max_concurrent_requests", null)
      max_idle_instances = lookup(each.value, "max_idle_instances", null)
      max_pending_latency = lookup(each.value, "max_pending_latency", null)
      max_total_instances = lookup(each.value, "max_total_instances", null)
      min_idle_instances = lookup(each.value, "min_idle_instances", null)
      min_pending_latency = lookup(each.value, "min_pending_latency", null)
      min_total_instances = lookup(each.value, "min_total_instances", null)
      dynamic "cpu_utilization" {
        for_each = lookup(each.value, "cpu_utilization", {target_utilization: 0.5})  # required default. Also see attribute below
        //noinspection HILUnresolvedReference
        content {
          target_utilization = lookup(each.value, "target_utilization", 0.5)
          aggregation_window_length = lookup(each.value, "aggregation_window_length", null)
        }
      }
      dynamic "disk_utilization" {
        for_each = lookup(each.value, "disk_utilization", {})
        //noinspection HILUnresolvedReference
        content {
          target_read_bytes_per_second = lookup(each.value, "target_read_bytes_per_second", null)
          target_read_ops_per_second = lookup(each.value, "target_read_ops_per_second", null)
          target_write_bytes_per_second = lookup(each.value, "target_write_bytes_per_second", null)
          target_write_ops_per_second = lookup(each.value, "target_write_ops_per_second", null)
        }
      }
      dynamic "network_utilization" {
        for_each = lookup(each.value, "network_utilization", {})
        //noinspection HILUnresolvedReference
        content {
          target_received_bytes_per_second = lookup(each.value, "target_received_bytes_per_second", null)
          target_received_packets_per_second = lookup(each.value, "target_received_packets_per_second", null)
          target_sent_bytes_per_second = lookup(each.value, "target_sent_bytes_per_second", null)
          target_sent_packets_per_second = lookup(each.value, "target_sent_packets_per_second", null)
        }
      }
      dynamic "request_utilization" {
        for_each = lookup(each.value, "request_utilization", {})
        //noinspection HILUnresolvedReference
        content {
          target_concurrent_requests = lookup(each.value, "target_concurrent_requests", null)
          target_request_count_per_second = lookup(each.value, "target_request_count_per_second", null)
        }
      }
    }
  }


  dynamic "manual_scaling" {
    for_each = lookup(each.value, "manual_scaling", {})
    //noinspection HILUnresolvedReference
    content {
      instances = lookup(manual_scaling, "value", null)
    }
  }


  dynamic "network" {
    for_each = lookup(each.value, "network", {})
    //noinspection HILUnresolvedReference
    content {
      name = lookup(each.value, "name", null)
      forwarded_ports = lookup(each.value, "forwarded_ports", null)
      instance_tag = lookup(each.value, "instance_tag", null)
      session_affinity = lookup(each.value, "session_affinity", null)
      subnetwork = lookup(each.value, "subnetwork", null)
    }
  }

  dynamic "api_config" {
    for_each = lookup(each.value, "api_config", {})
    //noinspection HILUnresolvedReference
    content {
      script = lookup(each.value, "script", null)
      auth_fail_action = lookup(each.value, "auth_fail_action", null)
      login = lookup(each.value, "login", null)
      security_level = lookup(each.value, "security_level", null)
      url = lookup(each.value, "url", null)
    }
  }

  //noinspection HILUnresolvedReference
  dynamic "liveness_check" {
    for_each = lookup(each.value, "liveness_check", null) == null ? {liveness_check: {path: "/"}} : {liveness_check: each.value.liveness_check}  # required default. Also see attribute below
    content {
      path = lookup(liveness_check.value, "path", "/")
      check_interval = lookup(liveness_check.value, "check_interval_sec", null)
      failure_threshold = lookup(liveness_check.value, "failure_threshold", null)
      host = lookup(liveness_check.value, "host", null)
      initial_delay = lookup(liveness_check.value, "initial_delay", null)
      success_threshold = lookup(liveness_check.value, "success_threshold", null)
      timeout = lookup(liveness_check.value, "timeout_sec", null)
    }
  }

  //noinspection HILUnresolvedReference
  dynamic "readiness_check" {
    for_each = lookup(each.value, "readiness_check", null) == null ? {readiness_check: {path: "/"}} : {readiness_check: each.value.readiness_check}  # required default. Also see attribute below
    content {
      path = lookup(readiness_check.value, "path", "/")
      app_start_timeout = lookup(readiness_check.value, "app_start_timeout_sec", null)
      check_interval = lookup(readiness_check.value, "check_interval_sec", null)
      failure_threshold = lookup(readiness_check.value, "failure_threshold", null)
      host = lookup(readiness_check.value, "host", null)
      success_threshold = lookup(readiness_check.value, "success_threshold", null)
      timeout = lookup(readiness_check.value, "timeout_sec", null)
    }
  }

  env_variables = {
    for key, value in lookup(each.value, "env_variables", {}):
    key => value
  }

  dynamic "resources" {
    for_each = lookup(each.value, "resources", {})
    //noinspection HILUnresolvedReference
    content {
      cpu = lookup(each.value, "cpu", null)
      disk_gb = lookup(each.value, "disk_gb", null)
      memory_gb = lookup(each.value, "memory_gb", null)
      dynamic "volumes" {
        for_each = lookup(each.value, "volumes", {})
        //noinspection HILUnresolvedReference
        content {
          name = lookup(each.value, "name", null)
          size_gb = lookup(each.value, "size_gb", null)
          volume_type = lookup(each.value, "volume_type", null)
        }
      }
    }
  }

  dynamic "vpc_access_connector" {
    for_each = lookup(each.value, "vpc_access_connector", {})
    //noinspection HILUnresolvedReference
    content {
      name = lookup(each.value, "name", null)
    }
  }

  # Terraform in-built properties
  noop_on_destroy = var.tf_noop_on_destroy
  delete_service_on_destroy = var.tf_delete_service_on_destroy
}

//noinspection HILUnresolvedReference
resource "google_app_engine_standard_app_version" "self" {
  for_each = local.gae_std_list

  project = google_project_iam_member.self.project

  version_id = lookup(each.value, "api_version", null)
  service = lookup(each.value, "service", "default")
  runtime = lookup(each.value, "runtime", null)
  instance_class = lookup(each.value, "instance_class", null)
  runtime_api_version = lookup(each.value, "runtime_api_version", null)
  threadsafe = lookup(each.value, "threadsafe", null)

  dynamic "deployment" {
    for_each = lookup(each.value, "deployment", {files: {}})
    content {
      dynamic "files" {
        for_each = lookup(each.value, "files", {source_url: "file://."})
        //noinspection HILUnresolvedReference
        content {
          name = lookup(each.value, "name", null)
          source_url = lookup(each.value, "source_url", "file://.")
          sha1_sum = lookup(each.value, "sha1_sum", null)
        }
      }
      dynamic "zip" {
        for_each = lookup(each.value, "zip", {})
        //noinspection HILUnresolvedReference
        content {
          source_url = lookup(each.value, "source_url", null)
          files_count = lookup(each.value, "files_count", null)
        }
      }
    }
  }

  dynamic "entrypoint" {
    for_each = lookup(each.value, "entrypoint", {})
    //noinspection HILUnresolvedReference
    content {
      shell = lookup(each.value, "shell", null)
    }
  }

  dynamic "handlers" {
    for_each = lookup(each.value, "handlers", [])
    content {
      auth_fail_action = lookup(handlers.value, "auth_fail_action", null)
      login = lookup(handlers.value, "login", null) == null ? null : "LOGIN_${upper(lookup(handlers.value, "login"))}"
      redirect_http_response_code = lookup(handlers.value, "redirect_http_response_code", null) == null ? null : "REDIRECT_HTTP_RESPONSE_CODE_${upper(lookup(handlers.value, "redirect_http_response_code"))}"
      security_level = lookup(handlers.value, "secure", null) == null ? null : "SECURE_${upper(lookup(handlers.value, "secure"))}"
      url_regex = lookup(handlers.value, "url", null)
      dynamic "script" {
        for_each = lookup(handlers.value, "script", null) == null ? [] : [1]
        content {
          script_path = lookup(handlers.value, "script", null)
        }
      }
      dynamic "static_files" {
        for_each = lookup(handlers.value, "static_files", null) == null ? [] : [1]
        content {
          application_readable = lookup(handlers.value, "application_readable", null)
          expiration = lookup(handlers.value, "expiration", null)
          mime_type = lookup(handlers.value, "mime_type", null)
          path = lookup(handlers.value, "static_files", null)
          require_matching_file = lookup(handlers.value, "require_matching_file", null)
          upload_path_regex = lookup(handlers.value, "upload", null)
          http_headers = lookup(handlers.value, "http_headers", {})
        }
      }
    }
  }

  libraries {}

  dynamic "basic_scaling" {
    for_each = lookup(each.value, "basic_scaling", {})
    content {
      max_instances = lookup(each.value, "max_instances", null)
    }
  }

  dynamic "automatic_scaling" {
    for_each = lookup(each.value, "automatic_scaling", {})  # required default. Also see attribute below
    //noinspection HILUnresolvedReference
    content {
      max_concurrent_requests = lookup(each.value, "max_concurrent_requests", null)
      max_idle_instances = lookup(each.value, "max_idle_instances", null)
      max_pending_latency = lookup(each.value, "max_pending_latency", null)
      min_idle_instances = lookup(each.value, "min_idle_instances", null)
      min_pending_latency = lookup(each.value, "min_pending_latency", null)
      standard_scheduler_settings {}
    }
  }


  dynamic "manual_scaling" {
    for_each = lookup(each.value, "manual_scaling", {})
    //noinspection HILUnresolvedReference
    content {
      instances = 4
    }
  }

  env_variables = {
    for key, value in lookup(each.value, "env_variables", {}):
    key => value
  }

  # Terraform in-built properties
  noop_on_destroy = var.tf_noop_on_destroy
  delete_service_on_destroy = var.tf_delete_service_on_destroy
}