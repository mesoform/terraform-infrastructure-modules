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

  version_id = lookup(each.value, "version_id", null) == null ? null : each.value.version_id
  service = lookup(each.value, "service", null) == null ? "default" : each.value.service
  runtime = lookup(each.value, "runtime", null) == null ? null : each.value.runtime
  default_expiration = lookup(each.value, "default_expiration", null) == null ? null : each.value.default_expiration
  inbound_services = lookup(each.value, "inbound_services", null) == null ? [] : each.value.inbound_services
  instance_class = lookup(each.value, "instance_class", null) == null ? null : each.value.instance_class
  nobuild_files_regex = lookup(each.value, "nobuild_files_regex", null) == null ? null : each.value.nobuild_files_regex
  runtime_api_version = lookup(each.value, "runtime_api_version", null) == null ? null : each.value.runtime_api_version
  runtime_channel = lookup(each.value, "runtime_channel", null) == null ? null : each.value.runtime_channel
  runtime_main_executable_path = lookup(each.value, "runtime_main_executable_path", null) == null ? null : each.value.runtime_main_executable_path
  serving_status = lookup(each.value, "serving_status", null) == null ? null : each.value.serving_status

  dynamic "deployment" {
    for_each = lookup(each.value, "deployment", {})
    content {
      dynamic "cloud_build_options" {
        for_each = lookup(each.value, "cloud_build_options", {})
        //noinspection HILUnresolvedReference
        content {
          app_yaml_path = lookup(each.value, "app_yaml_path", null) == null ? null : each.value.app_yaml_path
          cloud_build_timeout = lookup(each.value, "cloud_build_timeout", null) == null ? null : each.value.cloud_build_timeout
        }
      }
      dynamic "container" {
        for_each = lookup(each.value, "container", {})
        //noinspection HILUnresolvedReference
        content {
          image = lookup(each.value, "image", null) == null ? null : each.value.image
        }
      }
      dynamic "files" {
        for_each = lookup(each.value, "files", {})
        //noinspection HILUnresolvedReference
        content {
          name = lookup(each.value, "name", null) == null ? null : each.value.name
          source_url = lookup(each.value, "source_url", null) == null ? null : each.value.source_url
          sha1_sum = lookup(each.value, "sha1_sum", null) == null ? null : each.value.sha1_sum
        }
      }
      dynamic "zip" {
        for_each = lookup(each.value, "zip", {})
        //noinspection HILUnresolvedReference
        content {
          source_url = lookup(each.value, "source_url", null) == null ? null : each.value.source_url
          files_count = lookup(each.value, "files_count", null) == null ? null : each.value.files_count
        }
      }
    }
  }

  dynamic "endpoints_api_service" {
    for_each = lookup(each.value, "endpoints_api_service", {})
    //noinspection HILUnresolvedReference
    content {
      name = lookup(each.value, "name", null) == null ? null : each.value.name
      config_id = lookup(each.value, "config_id", null) == null ? null : each.value.config_id
      disable_trace_sampling = lookup(each.value, "disable_trace_sampling", null) == null ? null : each.value.disable_trace_sampling
      rollout_strategy = lookup(each.value, "rollout_strategy", null) == null ? null : each.value.rollout_strategy
    }
  }

  dynamic "entrypoint" {
    for_each = lookup(each.value, "entrypoint", {})
    //noinspection HILUnresolvedReference
    content {
      shell = lookup(each.value, "shell", null) == null ? null : each.value.shell
    }
  }

  dynamic "automatic_scaling" {
    for_each = lookup(each.value, "automatic_scaling", {cpu_utilization: {}})  # required default. Also see attribute below
    //noinspection HILUnresolvedReference
    content {
      cool_down_period = lookup(each.value, "cool_down_period", null) == null ? null : each.value.cool_down_period
      max_concurrent_requests = lookup(each.value, "max_concurrent_requests", null) == null ? null : each.value.max_concurrent_requests
      max_idle_instances = lookup(each.value, "max_idle_instances", null) == null ? null : each.value.max_idle_instances
      max_pending_latency = lookup(each.value, "max_pending_latency", null) == null ? null : each.value.max_pending_latency
      max_total_instances = lookup(each.value, "max_total_instances", null) == null ? null : each.value.max_total_instances
      min_idle_instances = lookup(each.value, "min_idle_instances", null) == null ? null : each.value.min_idle_instances
      min_pending_latency = lookup(each.value, "min_pending_latency", null) == null ? null : each.value.min_pending_latency
      min_total_instances = lookup(each.value, "min_total_instances", null) == null ? null : each.value.min_total_instances
      dynamic "cpu_utilization" {
        for_each = lookup(each.value, "cpu_utilization", {target_utilization: 0.5})  # required default. Also see attribute below
        //noinspection HILUnresolvedReference
        content {
          target_utilization = lookup(each.value, "target_utilization", null) == null ? 0.5 : each.value.target_utilization
          aggregation_window_length = lookup(each.value, "aggregation_window_length", null) == null ? null : each.value.aggregation_window_length
        }
      }
      dynamic "disk_utilization" {
        for_each = lookup(each.value, "disk_utilization", {})
        //noinspection HILUnresolvedReference
        content {
          target_read_bytes_per_second = lookup(each.value, "target_read_bytes_per_second", null) == null ? null : each.value.target_read_bytes_per_second
          target_read_ops_per_second = lookup(each.value, "target_read_ops_per_second", null) == null ? null : each.value.target_read_ops_per_second
          target_write_bytes_per_second = lookup(each.value, "target_write_bytes_per_second", null) == null ? null : each.value.target_write_bytes_per_second
          target_write_ops_per_second = lookup(each.value, "target_write_ops_per_second", null) == null ? null : each.value.target_write_ops_per_second
        }
      }
      dynamic "network_utilization" {
        for_each = lookup(each.value, "network_utilization", {})
        //noinspection HILUnresolvedReference
        content {
          target_received_bytes_per_second = lookup(each.value, "target_received_bytes_per_second", null) == null ? null : each.value.target_received_bytes_per_second
          target_received_packets_per_second = lookup(each.value, "target_received_packets_per_second", null) == null ? null : each.value.target_received_packets_per_second
          target_sent_bytes_per_second = lookup(each.value, "target_sent_bytes_per_second", null) == null ? null : each.value.target_sent_bytes_per_second
          target_sent_packets_per_second = lookup(each.value, "target_sent_packets_per_second", null) == null ? null : each.value.target_sent_packets_per_second
        }
      }
      dynamic "request_utilization" {
        for_each = lookup(each.value, "request_utilization", {})
        //noinspection HILUnresolvedReference
        content {
          target_concurrent_requests = lookup(each.value, "target_concurrent_requests", null) == null ? null : each.value.target_concurrent_requests
          target_request_count_per_second = lookup(each.value, "target_request_count_per_second", null) == null ? null : each.value.target_request_count_per_second
        }
      }
    }
  }


  dynamic "manual_scaling" {
    for_each = lookup(each.value, "manual_scaling", {})
    //noinspection HILUnresolvedReference
    content {
      instances = lookup(each.value, "instances", null) == null ? null : each.value.instances
    }
  }

  dynamic "network" {
    for_each = lookup(each.value, "network", {})
    //noinspection HILUnresolvedReference
    content {
      name = lookup(each.value, "name", null) == null ? null : each.value.name
      forwarded_ports = lookup(each.value, "forwarded_ports", null) == null ? null : each.value.forwarded_ports
      instance_tag = lookup(each.value, "instance_tag", null) == null ? null : each.value.instance_tag
      session_affinity = lookup(each.value, "session_affinity", null) == null ? null : each.value.session_affinity
      subnetwork = lookup(each.value, "subnetwork", null) == null ? null : each.value.subnetwork
    }
  }

  dynamic "api_config" {
    for_each = lookup(each.value, "api_config", {})
    //noinspection HILUnresolvedReference
    content {
      script = lookup(each.value, "script", null) == null ? null : each.value.script
      auth_fail_action = lookup(each.value, "auth_fail_action", null) == null ? null : each.value.auth_fail_action
      login = lookup(each.value, "login", null) == null ? null : each.value.login
      security_level = lookup(each.value, "security_level", null) == null ? null : each.value.security_level
      url = lookup(each.value, "url", null) == null ? null : each.value.url
    }
  }

  # possibly dynamic
  dynamic "liveness_check" {
    for_each = lookup(each.value, "liveness_check", {path: "/"})  # required default. Also see attribute below
    //noinspection HILUnresolvedReference
    content {
      path = lookup(each.value, "path", null) == null ? "/" : each.value.path
      check_interval = lookup(each.value, "check_interval", null) == null ? null : each.value.check_interval
      failure_threshold = lookup(each.value, "failure_threshold", null) == null ? null : each.value.failure_threshold
      host = lookup(each.value, "host", null) == null ? null : each.value.host
      initial_delay = lookup(each.value, "initial_delay", null) == null ? null : each.value.initial_delay
      success_threshold = lookup(each.value, "success_threshold", null) == null ? null : each.value.success_threshold
      timeout = lookup(each.value, "timeout", null) == null ? null : each.value.timeout
    }
  }

  # possibly dynamic
  dynamic "readiness_check" {
    for_each = lookup(each.value, "readiness_check", {path: "/"})  # required default. Also see attribute below
    //noinspection HILUnresolvedReference
    content {
      path = lookup(each.value, "path", null) == null ? "/" : each.value.path
      app_start_timeout = lookup(each.value, "app_start_timeout", null) == null ? null : each.value.app_start_timeout
      check_interval = lookup(each.value, "check_interval", null) == null ? null : each.value.check_interval
      failure_threshold = lookup(each.value, "failure_threshold", null) == null ? null : each.value.failure_threshold
      host = lookup(each.value, "host", null) == null ? null : each.value.host
      success_threshold = lookup(each.value, "success_threshold", null) == null ? null : each.value.success_threshold
      timeout = lookup(each.value, "timeout", null) == null ? null : each.value.timeout
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
      cpu = lookup(each.value, "cpu", null) == null ? null : each.value.cpu
      disk_gb = lookup(each.value, "disk_gb", null) == null ? null : each.value.disk_gb
      memory_gb = lookup(each.value, "memory_gb", null) == null ? null : each.value.memory_gb
      dynamic "volumes" {
        for_each = lookup(each.value, "volumes", {})
        //noinspection HILUnresolvedReference
        content {
          name = lookup(each.value, "name", null) == null ? null : each.value.name
          size_gb = lookup(each.value, "size_gb", null) == null ? null : each.value.size_gb
          volume_type = lookup(each.value, "volume_type", null) == null ? null : each.value.volume_type
        }
      }
    }
  }

  dynamic "vpc_access_connector" {
    for_each = lookup(each.value, "vpc_access_connector", {})
    //noinspection HILUnresolvedReference
    content {
      name = lookup(each.value, "name", null) == null ? null : each.value.name
    }
  }

  # Terraform in-built properties
  noop_on_destroy = var.tf_noop_on_destroy
  delete_service_on_destroy = var.tf_delete_service_on_destroy
}