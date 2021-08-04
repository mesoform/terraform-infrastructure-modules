terraform {
  required_version = ">= 0.14.0"
  experiments = [module_variable_optional_attrs]
}

data google_project default {
  project_id = var.project
}

data google_compute_health_check self {
  for_each = {for health_check in var.health_check : health_check.name => health_check}
  name     = each.key
  project  = var.project
}

//Updates the time for the version when the template is updated or certain properties of MIG are updated
resource time_static self {
  triggers = {
    deployment_version = var.deployment_version
    instance = var.deployment_version == "blue" ? module.secure_instance_template_blue.fingerprint : module.secure_instance_template_green.fingerprint
    update_policy = jsonencode(var.update_policy)
    health_check = jsonencode(var.health_check)
    named_ports = jsonencode(var.named_ports)
  }
}

//Updates the google_compute_disk_resource_policy_attachment when google_compute_resource_policy is updated
resource time_static snapshot {
  triggers = {
    snapshot_properties = jsonencode(var.snapshot_properties)
    daily_schedule = jsonencode(var.daily_schedule)
    weekly_schedule = jsonencode(var.weekly_schedule)
    hourly_schedule = jsonencode(var.hourly_schedule)
    retention_policy = jsonencode(var.retention_policy)
  }
}

resource google_compute_disk self {
  provider  = google-beta
  name      = "${var.name}-${var.zone}-disk"
  zone      = "${var.region}-${var.zone}"
  project   = var.project
  labels    = var.labels
  size      = var.disk_size
  interface = "NVME"
}

resource google_compute_resource_policy self {
  name = "${var.name}-${var.zone}-${time_static.snapshot.unix}"
  region = var.region
  project = var.project
  snapshot_schedule_policy {
    schedule{
      dynamic hourly_schedule {
        for_each = var.hourly_schedule == null ? [] : [1]
        content {
          hours_in_cycle = var.hourly_schedule.hours_in_cycle
          start_time = var.hourly_schedule.start_time
        }
      }
      dynamic daily_schedule {
        //If weekly or hourly schedule is specified ignore default daily schedule
        for_each = var.weekly_schedule != null || var.hourly_schedule != null ? [] : [1]
        content {
          days_in_cycle = var.daily_schedule.days_in_cycle
          start_time = var.daily_schedule.start_time
        }
      }
      dynamic weekly_schedule {
        for_each = var.weekly_schedule == null ? [] : [1]
        content {
          dynamic day_of_weeks{
            for_each = var.weekly_schedule
            content {
              day = day_of_weeks.value.day
              start_time = day_of_weeks.value.start_time
            }
          }
        }
      }
    }
    dynamic retention_policy {
      for_each = var.retention_policy == null ? [] : [1]
      content {
        max_retention_days = var.retention_policy.max_retention_days
        on_source_disk_delete = lookup(var.retention_policy, "on_source_disk_delete", null)
      }
    }
    dynamic snapshot_properties {
      for_each = var.snapshot_properties ==  null ? [] : [1]
      content {
        labels = lookup(var.snapshot_properties, "labels", null)
        storage_locations =  lookup(var.snapshot_properties, "storage_locations", null)
        guest_flush = lookup(var.snapshot_properties, "guest_flush", null)
}
    }
  }
}

resource google_compute_disk_resource_policy_attachment self{
  name = google_compute_resource_policy.self.name
  disk = google_compute_disk.self.name
  zone = "${var.region}-${var.zone}"
  project = var.project
}

module secure_instance_template_blue {
  source      = "../compute_engine/instance_template"
  project_id  = var.project
  description = "Secure Swarm zone template"
  service_account = {
    email  = local.service_account_email
    scopes = var.service_account_scopes
  }
  region               = var.region
  zone                 = var.zone
  enable_shielded_vm   = true
  name_prefix          = "${var.name}-${var.zone}-blue-"
  machine_type         = var.blue_instance_template.machine_type == null ? var.machine_type : var.blue_instance_template.machine_type
  source_image         = var.blue_instance_template.source_image == null ? var.source_image : var.blue_instance_template.source_image
  source_image_family  = var.blue_instance_template.source_image_family == null ?  var.source_image_family : var.blue_instance_template.source_image_family
  source_image_project = var.blue_instance_template.source_image_project == null ? var.source_image_project : var.blue_instance_template.source_image_project
  subnetwork_project   = var.blue_instance_template.subnetwork == null ? null : var.project
  network              = var.blue_instance_template.network == null ? var.network : var.blue_instance_template.network
  subnetwork           = var.blue_instance_template.subnetwork == null ? var.subnetwork : var.blue_instance_template.subnetwork
  access_config        = var.blue_instance_template.access_config == null ?  var.access_config: var.blue_instance_template.access_config
  on_host_maintenance  = local.blue_instance_template["security_level"]  == "confidential-1" ? "TERMINATE" : "MIGRATE"
  additional_disks = [{
    boot         = false
    auto_delete  = false
    device_name  = google_compute_disk.self.name
    disk_name    = google_compute_disk.self.name
    disk_size_gb = var.disk_size
    disk_type    = "pd-standard"
    mode         = "READ_WRITE"
  }]
  security_level = local.blue_instance_template["security_level"]
}


module secure_instance_template_green {
  source      = "../compute_engine/instance_template"
  project_id  = var.project
  description = "Secure Swarm zone template"
  service_account = {
    email  = local.service_account_email
    scopes = var.service_account_scopes
  }
  region               = var.region
  zone                 = var.zone
  enable_shielded_vm   = true
  name_prefix          = "${var.name}-${var.zone}-green-"
  machine_type         = var.green_instance_template.machine_type == null ? var.machine_type : var.green_instance_template.machine_type
  source_image         = var.green_instance_template.source_image == null ? var.source_image : var.green_instance_template.source_image
  source_image_family  = var.green_instance_template.source_image_family == null ?  var.source_image_family : var.green_instance_template.source_image_family
  source_image_project = var.green_instance_template.source_image_project == null ? var.source_image_project : var.green_instance_template.source_image_project
  subnetwork_project   = var.green_instance_template.subnetwork == null ? null : var.project
  network              = var.green_instance_template.network == null? var.network : var.green_instance_template.network
  subnetwork           = var.green_instance_template.subnetwork == null? var.subnetwork : var.green_instance_template.subnetwork
  access_config        = var.green_instance_template.access_config == null?  var.access_config: var.green_instance_template.access_config
  on_host_maintenance  = local.green_instance_template["security_level"]  == "confidential-1" ? "TERMINATE" : "MIGRATE"
  additional_disks = [{
    boot         = false
    auto_delete  = false
    device_name  = google_compute_disk.self.name
    disk_name    = google_compute_disk.self.name
    disk_size_gb = var.disk_size
    disk_type    = "pd-standard"
    mode         = "READ_WRITE"
  }]
  security_level = local.green_instance_template["security_level"]
}

resource google_compute_instance_group_manager self {
  provider          = google-beta
  base_instance_name = "${var.name}-${var.zone}"
  name               = "${var.name}-${var.zone}"
  zone               = "${var.region}-${var.zone}"
  project            = var.project
  wait_for_instances_status = "STABLE"
  target_size        = var.target_size

  version {
    name              = var.version_name == null ? formatdate("YYYYMMDDhhmm", time_static.self.rfc3339) : var.version_name
    instance_template = var.deployment_version == "blue" ? module.secure_instance_template_blue.self_link : module.secure_instance_template_green.self_link
}

  dynamic "auto_healing_policies" {
    for_each = [for health_check in var.health_check: {
      health_check      = data.google_compute_health_check.self[health_check["name"]].id
      initial_delay_sec = tonumber(lookup(health_check, "initial_delay_sec", 30))
    }]
    content {
      health_check      = auto_healing_policies.value.health_check
      initial_delay_sec = auto_healing_policies.value.initial_delay_sec
    }
  }

  stateful_disk {
    device_name = google_compute_disk.self.name
    delete_rule = "NEVER"
  }

  dynamic "update_policy" {
    for_each = var.update_policy
    content {
      type                         = update_policy.value.type
      minimal_action               = update_policy.value.minimal_action
      max_surge_fixed              = lookup(update_policy.value, "max_surge_fixed", null)
      max_surge_percent            = lookup(update_policy.value, "max_surge_percent", null)
      max_unavailable_fixed        = lookup(update_policy.value, "max_unavailable_fixed", null)
      max_unavailable_percent      = lookup(update_policy.value, "max_unavailable_percent", null)
      min_ready_sec                = lookup(update_policy.value, "min_ready_sec", null)
      replacement_method           = lookup(update_policy.value, "replacement_method", null)
    }
  }
  dynamic "named_port" {
    for_each = var.named_ports
    content {
      name = named_port.value["name"]
      port = named_port.value["port"]
    }
  }
}