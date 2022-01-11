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

module secure_instance_template_blue {
  source      = "../compute_engine/instance_template"
  project_id  = var.project
  description = "Secure Swarm zone template"
  service_account = {
    email  = local.service_account_email
    scopes = var.blue_instance_template.service_account_scopes == null ? var.service_account_scopes : var.blue_instance_template.service_account_scopes
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
  network_ip           = var.blue_instance_template.network_ip == null ? var.network_ip : var.blue_instance_template.network_ip[var.zone]
  access_config        = var.blue_instance_template.access_config == null ?  var.access_config: var.blue_instance_template.access_config
  on_host_maintenance  = local.blue_instance_template["security_level"]  == "confidential-1" ? "TERMINATE" : "MIGRATE"
  disk_interface       = var.security_level == "confidential-1" ? "NVME" : "SCSI"
  auto_delete          = !var.stateful_boot
  additional_disks     = [{
    boot         = false
    auto_delete  = false
    device_name  = "${var.name}-${var.zone}-data"
    disk_name    = "${var.name}-${var.zone}-data"
    disk_size_gb = var.disk_size
    disk_type    = var.disk_type
    mode         = "READ_WRITE"
    interface    = var.security_level == "confidential-1" ? "NVME" : "SCSI"
    resource_policies = var.disk_resource_policies
  }]
  security_level = local.blue_instance_template["security_level"]
  tags           = var.tags
  metadata       = var.metadata

}


module secure_instance_template_green {
  source      = "../compute_engine/instance_template"
  project_id  = var.project
  description = "Secure Swarm zone template"
  service_account = {
    email  = local.service_account_email
    scopes = var.green_instance_template.service_account_scopes == null ? var.service_account_scopes : var.green_instance_template.service_account_scopes
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
  network              = var.green_instance_template.network == null ? var.network : var.green_instance_template.network
  subnetwork           = var.green_instance_template.subnetwork == null? var.subnetwork : var.green_instance_template.subnetwork
  network_ip           = var.green_instance_template.network_ip == null ? var.network_ip : var.green_instance_template.network_ip[var.zone]
  access_config        = var.green_instance_template.access_config == null?  var.access_config: var.green_instance_template.access_config
  on_host_maintenance  = local.green_instance_template["security_level"]  == "confidential-1" ? "TERMINATE" : "MIGRATE"
  disk_interface       = var.security_level == "confidential-1" ? "NVME" : "SCSI"
  auto_delete          = !var.stateful_boot
  disk_size_gb         = var.boot_disk_size
  boot_device_name     = "${var.name}-${var.zone}-boot"
  additional_disks = [{
    boot         = false
    auto_delete  = false
    device_name  = "${var.name}-${var.zone}-data"
    disk_name    = "${var.name}-${var.zone}-data"
    disk_size_gb = var.disk_size
    disk_type    = var.disk_type
    mode         = "READ_WRITE"
    interface    = var.security_level == "confidential-1" ? "NVME" : "SCSI"
    resource_policies = var.disk_resource_policies
  }]
  security_level = local.green_instance_template["security_level"]
  tags           = var.tags
  metadata       = var.metadata
}

resource google_compute_instance_group_manager self {
  provider          = google-beta
  base_instance_name = "${var.name}-${var.zone}"
  name               = "${var.name}-${var.zone}"
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

  stateful_disk {
    device_name = "${var.name}-${var.zone}-data"
    delete_rule = "NEVER"
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
