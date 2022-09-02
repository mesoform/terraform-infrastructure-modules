locals {
  name = var.zone == null ? var.name : "${var.name}-${var.zone}"

  boot_device_name = var.boot_device_name == null ? "${local.name}-boot" : var.boot_device_name

  blue_instance_template = {
    description            = var.instance_template_description
    service_account_scopes = var.blue_instance_template.service_account_scopes == null ? var.service_account_scopes : var.blue_instance_template.service_account_scopes
    machine_type           = var.blue_instance_template.machine_type == null ? var.machine_type : var.blue_instance_template.machine_type
    source_image           = var.blue_instance_template.source_image == null ? var.source_image : var.blue_instance_template.source_image
    source_image_family    = var.blue_instance_template.source_image_family == null ? var.source_image_family : var.blue_instance_template.source_image_family
    source_image_project   = var.blue_instance_template.source_image_project == null ? var.source_image_project : var.blue_instance_template.source_image_project
    network                = var.blue_instance_template.network == null ? var.network : var.blue_instance_template.network
    subnetwork             = var.blue_instance_template.subnetwork == null? var.subnetwork : var.blue_instance_template.subnetwork
    network_ip             = var.blue_instance_template.network_ip == null ? var.network_ip : var.blue_instance_template.network_ip
    access_config          = var.blue_instance_template.access_config == null?  var.access_config: var.blue_instance_template.access_config
    security_level         = var.blue_instance_template.security_level == null ? var.security_level : contains(["secure-1", "confidential-1"], var.blue_instance_template["security_level"]) ? var.blue_instance_template["security_level"] : null
    boot_disk_size         = var.blue_instance_template.boot_disk_size == null ? var.boot_disk_size : var.blue_instance_template.boot_disk_size
    boot_device_name       = var.blue_instance_template.boot_device_name == null ? var.boot_device_name == null ? "${local.name}-boot" : var.boot_device_name : var.blue_instance_template.boot_device_name
    disk_size              = var.blue_instance_template.disk_size == null ? var.disk_size : var.blue_instance_template.disk_size
    disk_type              = var.blue_instance_template.disk_type == null ? var.disk_type : var.blue_instance_template.disk_type
    resource_policies      = var.blue_instance_template.disk_resource_policies == null ? var.disk_resource_policies : var.blue_instance_template.disk_resource_policies
    tags                   = var.blue_instance_template.tags == null ? var.tags : var.blue_instance_template.tags
    metadata               = var.blue_instance_template.metadata == null ? var.metadata : var.blue_instance_template.metadata
  }

  green_instance_template = {
    description            = var.instance_template_description
    service_account_scopes = var.green_instance_template.service_account_scopes == null ? var.service_account_scopes : var.green_instance_template.service_account_scopes
    machine_type           = var.green_instance_template.machine_type == null ? var.machine_type : var.green_instance_template.machine_type
    source_image           = var.green_instance_template.source_image == null ? var.source_image : var.green_instance_template.source_image
    source_image_family    = var.green_instance_template.source_image_family == null ? var.source_image_family : var.green_instance_template.source_image_family
    source_image_project   = var.green_instance_template.source_image_project == null ? var.source_image_project : var.green_instance_template.source_image_project
    network                = var.green_instance_template.network == null ? var.network : var.green_instance_template.network
    subnetwork             = var.green_instance_template.subnetwork == null? var.subnetwork : var.green_instance_template.subnetwork
    network_ip             = var.green_instance_template.network_ip == null ? var.network_ip : var.green_instance_template.network_ip
    access_config          = var.green_instance_template.access_config == null?  var.access_config: var.green_instance_template.access_config
    security_level         = var.green_instance_template.security_level == null ? var.security_level : contains(["secure-1", "confidential-1"], var.green_instance_template["security_level"]) ? var.green_instance_template["security_level"] : null
    boot_disk_size         = var.green_instance_template.boot_disk_size == null ? var.boot_disk_size : var.green_instance_template.boot_disk_size
    boot_device_name       = var.green_instance_template.boot_device_name == null ? var.boot_device_name == null ? "${local.name}-boot" : var.boot_device_name : var.green_instance_template.boot_device_name
    disk_size              = var.green_instance_template.disk_size == null ? var.disk_size : var.green_instance_template.disk_size
    disk_type              = var.green_instance_template.disk_type == null ? var.disk_type : var.green_instance_template.disk_type
    resource_policies      = var.green_instance_template.disk_resource_policies == null ? var.disk_resource_policies : var.green_instance_template.disk_resource_policies
    tags                   = var.green_instance_template.tags == null ? var.tags : var.green_instance_template.tags
    metadata               = var.green_instance_template.metadata == null ? var.metadata : var.green_instance_template.metadata
  }

  stateful_boot_disk = var.stateful_boot ? [{
    device_name = local.boot_device_name
    delete_rule = var.stateful_boot_delete_rule
  }] : []
}

