locals {
  service_account_email = var.service_account_email == "" ? "${data.google_project.default.number}@-compute@developer.gserviceaccount.com" : var.service_account_email

  blue_instance_template = lookup(var.blue_instance_template, "security_level", null) == null ? merge(
    var.blue_instance_template, { security_level = var.security_level
  }) : contains(["secure-1", "confidential-1"], var.blue_instance_template["security_level"]) ? var.blue_instance_template : merge(var.blue_instance_template, { security_level = "confidential-1" })

  green_instance_template = lookup(var.blue_instance_template, "security_level", null) == null ? merge(
    var.blue_instance_template, { security_level = var.security_level }
  ) : contains(["secure-1", "confidential-1"], var.blue_instance_template["security_level"]) ? var.blue_instance_template : merge(var.blue_instance_template, { security_level = "confidential-1" })
}

