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
resource "google_project" "self" {
  name = var.google_project
  project_id = var.google_project
  org_id = var.google_org_id
  billing_account = var.google_billing_account
}

resource "google_app_engine_application" "self" {
  project = google_project.self.project_id
  location_id = "us-central"
}

resource "google_project_service" "self" {
  project = google_project.self.project_id
  service = "appengineflex.googleapis.com"

  disable_dependent_services = false
}

resource "google_project_iam_member" "self" {
  project = google_project_service.self.project
  role = "roles/compute.networkUser"
  member = "serviceAccount:service-${google_project.self.number}@gae-api-prod.google.com.iam.gserviceaccount.com"
}

//noinspection HILUnresolvedReference
resource "google_app_engine_flexible_app_version" "self" {
  for_each = local.gae_flex_list

  project = google_project_iam_member.self.project

  version_id = lookup(each.value, "version_id", null) == null ? null : each.value.version_id
  service = lookup(each.value, "service", null) == null ? "default" : each.value.service
  runtime = lookup(each.value, "runtime", null) == null ? null : each.value.runtime
  default_expiration = lookup(each.value, "runtime", null) == null ? null : each.value.runtime
  inbound_services = []
  instance_class = ""
  nobuild_files_regex = ""
  runtime_api_version = ""
  runtime_channel = ""
  runtime_main_executable_path = ""
  serving_status = ""

  deployment {
    cloud_build_options {
      app_yaml_path = ""
      cloud_build_timeout = ""
    }
    container {
      image = ""
    }
    files {
      name = ""
      source_url = ""
      sha1_sum = ""
    }
    zip {
      source_url = ""
      files_count = 0
    }

  }

  endpoints_api_service {
    name = ""
    config_id = ""
    disable_trace_sampling = true
    rollout_strategy = ""
  }

  entrypoint {
    shell = ""
  }

  dynamic "automatic_scaling" {
    //noinspection HILUnresolvedReference
    for_each = lookup(each.value, "automatic_scaling", {})
    content {
      cool_down_period = ""
      max_concurrent_requests = 0
      max_idle_instances = 0
      max_pending_latency = ""
      max_total_instances = 0
      min_idle_instances = 0
      min_pending_latency = ""
      min_total_instances = 0
      # possibly dynamic
      cpu_utilization {
        target_utilization = 0
        aggregation_window_length = ""
      }
      # possibly dynamic
      disk_utilization {
        target_read_bytes_per_second = 0
        target_read_ops_per_second = 0
        target_write_bytes_per_second = 0
        target_write_ops_per_second = 0
      }
      # possibly dynamic
      network_utilization {
        target_received_bytes_per_second = 0
        target_received_packets_per_second = 0
        target_sent_bytes_per_second = 0
        target_sent_packets_per_second = 0
      }
      # possibly dynamic
      request_utilization {
        target_concurrent_requests = 0
        target_request_count_per_second = ""
      }
    }

  }

  //noinspection HILUnresolvedReference
  dynamic "manual_scaling" {
    for_each = lookup(each.value, "manual_scaling", {})
    content {
      instances = 0
    }
  }

  network {
    name = ""
    forwarded_ports = []
    instance_tag = ""
    session_affinity = true
    subnetwork = ""
  }

  api_config {
    script = ""
    auth_fail_action = ""
    login = ""
    security_level = ""
    url = ""
  }

  # possibly dynamic
  liveness_check {
    path = "/"
    check_interval = ""
    failure_threshold = 0
    host = ""
    initial_delay = ""
    success_threshold = 0
    timeout = ""
  }

  # possibly dynamic
  readiness_check {
    path = "/"
    app_start_timeout = ""
    check_interval = ""
    failure_threshold = 0
    host = ""
    success_threshold = 0
    timeout = ""
  }

  env_variables = {
    for key, value in lookup(each.value, "env_variables", {}):
      key => value
  }

  resources {
    cpu = 0
    disk_gb = 0
    memory_gb = 0
    # possibly dynamic
    volumes {
      name = ""
      size_gb = 0
      volume_type = ""
    }
  }

  vpc_access_connector {
    name = ""
  }

  # Terraform in-built properties
  noop_on_destroy = var.tf_noop_on_destroy
  delete_service_on_destroy = var.tf_delete_service_on_destroy
}