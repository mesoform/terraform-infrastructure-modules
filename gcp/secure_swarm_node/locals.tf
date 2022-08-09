locals {
  name = var.zone == null ? var.name : "${var.name}-${var.zone}"
  blue_instance_template = lookup(var.blue_instance_template, "security_level", null) == null ? merge(
    var.blue_instance_template, { security_level = var.security_level
  }) : contains(["secure-1", "confidential-1"], var.blue_instance_template["security_level"]) ? var.blue_instance_template : merge(var.blue_instance_template, { security_level = "confidential-1" })

  green_instance_template = lookup(var.green_instance_template, "security_level", null) == null ? merge(
    var.green_instance_template, { security_level = var.security_level }
  ) : contains(["secure-1", "confidential-1"], var.green_instance_template["security_level"]) ? var.green_instance_template : merge(var.green_instance_template, { security_level = "confidential-1" })

  boot_device_name = var.boot_device_name == null ? "${local.name}-boot" : var.boot_device_name

  stateful_boot_disk = var.stateful_boot ? [{
    device_name = local.boot_device_name
    delete_rule = var.stateful_boot_delete_rule
  }] : []
}

