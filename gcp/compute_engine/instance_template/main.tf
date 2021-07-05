/**
 * Copyright 2019 Google LLC
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

###############
# Data Sources
###############
data "google_compute_image" "image" {
  project = var.source_image != "" ? var.source_image_project : "debian-cloud"
  name    = var.source_image != "" ? var.source_image : "debian-10-buster-v20200714"
}

data "google_compute_image" "image_family" {
  project = var.source_image_family != "" ? var.source_image_project : "debian-cloud"
  family  = var.source_image_family != "" ? var.source_image_family : "debian-10"
}

#########
# Locals
#########

locals {
  boot_disk = [
    {
      source_image = var.source_image != "" ? data.google_compute_image.image.self_link : data.google_compute_image.image_family.self_link
      disk_size_gb = var.disk_size_gb
      disk_type    = var.disk_type
      auto_delete  = var.auto_delete
      boot         = "true"
    },
  ]

  all_disks = concat(local.boot_disk, var.additional_disks)
}

####################
# Instance Template
####################
resource google_compute_instance_template self {
  name_prefix             = var.name_prefix
  description             = var.description
  project                 = var.project_id
  machine_type            = var.machine_type
  labels                  = var.labels
  metadata                = var.metadata
  tags                    = var.tags
  can_ip_forward          = var.can_ip_forward
  metadata_startup_script = var.startup_script
  region                  = var.region

  dynamic "disk" {
    for_each = local.all_disks
    //noinspection HILUnresolvedReference
    content {
      auto_delete  = lookup(disk.value, "auto_delete", null)
      boot         = lookup(disk.value, "boot", null)
      device_name  = lookup(disk.value, "device_name", null)
      disk_name    = lookup(disk.value, "disk_name", null)
      disk_size_gb = lookup(disk.value, "disk_size_gb", null)
      disk_type    = lookup(disk.value, "disk_type", null)
      interface    = lookup(disk.value, "interface", null)
      mode         = lookup(disk.value, "mode", null)
      source       = lookup(disk.value, "source", null)
      source_image = lookup(disk.value, "source_image", null)
      type         = lookup(disk.value, "type", null)

      dynamic "disk_encryption_key" {
        for_each = lookup(disk.value, "disk_encryption_key", [])
        content {
          kms_key_self_link = lookup(disk_encryption_key.value, "kms_key_self_link", null)
        }
      }
    }
  }

  dynamic "service_account" {
    for_each = [var.service_account]
    content {
      email  = lookup(service_account.value, "email", null)
      scopes = lookup(service_account.value, "scopes", null)
    }
  }

  network_interface {
    network            = var.network
    subnetwork         = var.subnetwork
    subnetwork_project = var.subnetwork_project
    network_ip         = var.network_ip
    dynamic "access_config" {
      for_each = lookup(var.access_config, var.zone, [])
      content {
        nat_ip       = lookup(access_config.value, "nat_ip", null)
        network_tier = lookup(access_config.value, "network_tier", null)
      }
    }
  }

  lifecycle {
    create_before_destroy = "true"
  }

  # scheduling must have automatic_restart be false when preemptible is true.
  scheduling {
    preemptible       = var.preemptible
    automatic_restart = !var.preemptible
  }

  //noinspection HCLUnknownBlockType
  confidential_instance_config{
    enable_confidential_compute = var.security_level == "confidential-1" ? true : false
  }

  shielded_instance_config {
    enable_secure_boot          = var.security_level == "standard" ? false : true
    enable_vtpm                 = var.security_level == "standard" ? false : true
    enable_integrity_monitoring = var.security_level == "standard" ? false : true
  }


  dynamic "guest_accelerator" {
    for_each = {}
    content {
      count = 0
      type  = ""
    }
  }
}