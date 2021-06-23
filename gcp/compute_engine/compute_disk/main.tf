resource "null_resource" "secure_computtagse_disk" {
  for_each = length(var.guest_os_ft) > 0 ? var.zones : []
  provisioner "local-exec" {
    command = "gcloud beta compute disks create ${var.name} --guest-os-features=${join(",", var.guest_os_ft)} --interface=${var.interface} --size=${var.size} --zone ${var.region}-${each.value} --project ${var.project}"
  }
}

resource "google_compute_disk" "default" {
  for_each                  = length(var.guest_os_ft) == 0 ? var.zones : []
  provider                  = google-beta
  name                      = "${var.name}-${each.value}-data"
  zone                      = "${var.region}-${each.value}"
  description               = var.description
  project                   = var.project
  labels                    = var.labels
  interface                 = var.interface
  size                      = var.size
  physical_block_size_bytes = var.physical_block_size_bytes
  type                      = var.type
  image                     = var.image
  resource_policies         = var.resource_policies
  provisioned_iops          = var.provisioned_iops
  snapshot                  = var.snapshot
  dynamic "source_image_encryption_key" {
    for_each = var.source_image_encryption_key
    content {
      raw_key                 = lookup(source_image_encryption_key.value, "raw_key", null)
      sha256                  = lookup(source_image_encryption_key.value, "sha256", null)
      kms_key_self_link       = lookup(source_image_encryption_key.value, "kms_key_self_link", null)
      kms_key_service_account = lookup(source_image_encryption_key.value, "kms_key_service_account", null)
    }
  }
  dynamic "disk_encryption_key" {
    for_each = var.disk_encryption_key
    content {
      raw_key                 = lookup(disk_encryption_key.value, "raw_key", null)
      sha256                  = lookup(disk_encryption_key.value, "sha256", null)
      kms_key_self_link       = lookup(disk_encryption_key.value, "kms_key_self_link", null)
      kms_key_service_account = lookup(disk_encryption_key.value, "kms_key_service_account", null)
    }
  }
  dynamic "source_snapshot_encryption_key" {
    for_each = var.source_snapshot_encryption_key
    content {
      raw_key                 = lookup(source_snapshot_encryption_key.value, "raw_key", null)
      sha256                  = lookup(source_snapshot_encryption_key.value, "sha256", null)
      kms_key_self_link       = lookup(source_snapshot_encryption_key.value, "kms_key_self_link", null)
      kms_key_service_account = lookup(source_snapshot_encryption_key.value, "kms_key_service_account", null)
    }
  }
}


