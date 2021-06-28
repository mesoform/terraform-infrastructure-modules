data google_project default {
  project_id = var.project
}



locals {
  service_account_email = var.service_account_email == "" ? "${data.google_project.default.number}@-compute@developer.gserviceaccount.com" : var.service_account_email
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

module secure_instance_template {
  source      = "../compute_engine/instance_template"
  project_id  = var.project
  description = "Secure Swarm zone template"
  service_account = {
    email  = local.service_account_email
    scopes = var.service_account_scopes
  }
  zone                 = var.zone
  enable_shielded_vm   = true
  name_prefix          = var.name
  machine_type         = var.machine_type
  source_image         = var.source_image
  source_image_family  = var.source_image_family
  source_image_project = var.source_image_project
  subnetwork_project   = var.project
  network              = var.network
  subnetwork           = var.subnetwork
  access_config        = var.access_config
  additional_disks = [{
    boot         = false
    auto_delete  = false
    device_name  = google_compute_disk.self.name
    disk_name    = google_compute_disk.self.name
    disk_size_gb = var.disk_size
    disk_type    = "pd-standard"
    mode         = "READ_WRITE"
  }]
  security_level = var.security_level
}

data google_compute_health_check self {
  for_each = {for health_check in var.health_check : health_check.name => health_check}
  name     = each.key
  project  = var.project
}

resource google_compute_instance_group_manager self {
  base_instance_name = "${var.name}-${var.zone}-"
  name               = "${var.name}-${var.zone}"
  zone               = "${var.region}-${var.zone}"
  project            = var.project
  version {
    name              = var.version_name == null ? formatdate("YYYYMMDDhhmm", timestamp()) : var.version_name
    instance_template = module.secure_instance_template.id
  }
  dynamic "named_port" {
    for_each = var.named_ports
    content {
      name = named_port.value.name
      port = named_port.value.port
    }
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
      instance_redistribution_type = lookup(update_policy.value, "instance_redistribution_type", null)
      max_surge_fixed              = lookup(update_policy.value, "max_surge_fixed", null)
      max_surge_percent            = lookup(update_policy.value, "max_surge_percent", null)
      max_unavailable_fixed        = lookup(update_policy.value, "max_unavailable_fixed", null)
      max_unavailable_percent      = lookup(update_policy.value, "max_unavailable_percent", null)
      min_ready_sec                = lookup(update_policy.value, "min_ready_sec", null)
      minimal_action               = update_policy.value.minimal_action
      type                         = update_policy.value.type
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

