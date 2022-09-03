//Keep this local variable here, as moving it to locals.tf breaks unit tests
locals {
  service_account_email = var.service_account_email == "" ? "${data.google_project.default.number}@-compute@developer.gserviceaccount.com" : var.service_account_email
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

resource time_static regional_mig_update {
  triggers = {
    deployment_version = var.deployment_version
    instance = var.deployment_version == "blue" ? module.secure_instance_template_blue.fingerprint : module.secure_instance_template_green.fingerprint
    regional_update_policy = jsonencode(var.regional_update_policy)
    health_check = jsonencode(var.health_check)
    named_ports = jsonencode(var.named_ports)
  }
}

module secure_instance_template_blue {
  source      = "../compute_engine/instance_template"
  project_id  = var.project
  description = local.blue_instance_template.description
  service_account = {
    email  = local.service_account_email
    scopes = local.blue_instance_template.service_account_scopes
  }
  region               = var.region
  zone                 = var.zone
  enable_shielded_vm   = true
  name_prefix          = "${local.name}-blue-"
  machine_type         = local.blue_instance_template.machine_type
  source_image         = local.blue_instance_template.source_image
  source_image_family  = local.blue_instance_template.source_image_family
  source_image_project = local.blue_instance_template.source_image_project
  network              = local.blue_instance_template.network
  subnetwork           = local.blue_instance_template.subnetwork
  subnetwork_project   = local.blue_instance_template.subnetwork == null ? null : var.project
  network_ip           = local.blue_instance_template.network_ip
  access_config        = local.blue_instance_template.access_config
  on_host_maintenance  = local.blue_instance_template.security_level  == "confidential-1" ? "TERMINATE" : "MIGRATE"
  disk_interface       = local.blue_instance_template.security_level == "confidential-1" ? "NVME" : "SCSI"
  auto_delete          = !var.stateful_boot
  disk_size_gb         = local.blue_instance_template.boot_disk_size
  boot_device_name     = local.blue_instance_template.boot_device_name
  additional_disks     = var.persistent_disk ? [{
    boot         = false
    auto_delete  = false
    device_name  = "${local.name}-data"
    disk_name    = "${local.name}-data"
    disk_size_gb = local.blue_instance_template.disk_size
    disk_type    = local.blue_instance_template.disk_type
    mode         = "READ_WRITE"
    interface    = local.blue_instance_template.security_level == "confidential-1" ? "NVME" : "SCSI"
    resource_policies = local.blue_instance_template.resource_policies
  }] : []
  security_level = local.blue_instance_template.security_level
  tags           = local.blue_instance_template.tags
  metadata       = local.blue_instance_template.metadata
}


module secure_instance_template_green {
  source      = "../compute_engine/instance_template"
  project_id  = var.project
  description = local.green_instance_template.description
  service_account = {
    email  = local.service_account_email
    scopes = local.green_instance_template.service_account_scopes
  }
  region               = var.region
  zone                 = var.zone
  enable_shielded_vm   = true
  name_prefix          = "${local.name}-green-"
  machine_type         = local.green_instance_template.machine_type
  source_image         = local.green_instance_template.source_image
  source_image_family  = local.green_instance_template.source_image_family
  source_image_project = local.green_instance_template.source_image_project
  network              = local.green_instance_template.network
  subnetwork           = local.green_instance_template.subnetwork
  subnetwork_project   = local.green_instance_template.subnetwork == null ? null : var.project
  network_ip           = local.green_instance_template.network_ip
  access_config        = local.green_instance_template.access_config
  on_host_maintenance  = local.green_instance_template.security_level  == "confidential-1" ? "TERMINATE" : "MIGRATE"
  disk_interface       = local.green_instance_template.security_level == "confidential-1" ? "NVME" : "SCSI"
  auto_delete          = !var.stateful_boot
  disk_size_gb         = local.green_instance_template.boot_disk_size
  boot_device_name     = local.green_instance_template.boot_device_name
  additional_disks     = var.persistent_disk ? [{
    boot         = false
    auto_delete  = false
    device_name  = "${local.name}-data"
    disk_name    = "${local.name}-data"
    disk_size_gb = local.green_instance_template.disk_size
    disk_type    = local.green_instance_template.disk_type
    mode         = "READ_WRITE"
    interface    = local.green_instance_template.security_level == "confidential-1" ? "NVME" : "SCSI"
    resource_policies = local.green_instance_template.resource_policies
  }] : []
  security_level = local.green_instance_template.security_level
  tags           = local.green_instance_template.tags
  metadata       = local.green_instance_template.metadata
}

resource google_compute_instance_group_manager self {
  count = var.zone == null ? 0 : 1
  provider          = google-beta
  base_instance_name = local.name
  name               = local.name
  zone               = "${var.region}-${var.zone}"
  project            = var.project
  wait_for_instances = var.wait_for_instances
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

  # For optional persistent disk
  dynamic "stateful_disk" {
    for_each    = var.stateful_instance_group && var.persistent_disk ? [true] : []
    content {
      device_name = "${local.name}-data"
      delete_rule = "NEVER"
    }
  }

  # For optional stateful boot disk
  dynamic "stateful_disk" {
    for_each = local.stateful_boot_disk
    //noinspection HILUnresolvedReference
    content {
      device_name = stateful_disk.value.device_name
      delete_rule = stateful_disk.value.delete_rule
    }
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
  timeouts {
    create = "10m"
    update = "10m"
  }
}

resource google_compute_region_instance_group_manager self {
  count = var.zone == null ? 1 : 0
  provider          = google-beta
  base_instance_name = local.name
  name               = local.name
  region             = var.region
  project            = var.project
  wait_for_instances = var.wait_for_instances
  wait_for_instances_status = "STABLE"
  target_size        = var.target_size

  version {
    name              = var.version_name == null ? formatdate("YYYYMMDDhhmm", time_static.regional_mig_update.rfc3339) : var.version_name
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

  # For optional persistent disk
  dynamic "stateful_disk" {
    for_each    = var.stateful_instance_group  && var.persistent_disk ? [true] : []
    content {
      device_name = "${local.name}-data"
      delete_rule = "NEVER"
    }
  }

  # For optional stateful boot disk
  dynamic "stateful_disk" {
    for_each = local.stateful_boot_disk
    //noinspection HILUnresolvedReference
    content {
      device_name = stateful_disk.value.device_name
      delete_rule = stateful_disk.value.delete_rule
    }
  }

  dynamic "update_policy" {
    for_each = var.regional_update_policy
    content {
      type                         = update_policy.value.type
      minimal_action               = update_policy.value.minimal_action
      instance_redistribution_type = lookup(update_policy.value, "instance_redistribution_type", null )
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
  timeouts {
    create = "10m"
    update = "10m"
  }
}