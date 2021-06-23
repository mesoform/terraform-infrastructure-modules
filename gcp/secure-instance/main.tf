locals {
  name    = "secure-swarm"
  region  = "europe-west2"
  zones   = ["a", "b", "c"]
  project = "test-secure-swarm"
  secure_disk = {
    interface = "NVME"
    size      = 200
  }
  service_account_email = var.service_account_email == "" ? "${data.google_project.default.number}@-compute@developer.gserviceaccount.com" : var.service_account_email
}

data "google_project" "default" {
  project_id = var.project
}

module "secure_disk" {
  source    = "../compute_engine/compute_disk"
  description = "Secure Swarm persistent disk"
  project   = var.project
  name      = var.name
  region    = var.region
  zones     = var.zones
  interface = "NVME"
  size      = var.disk_size
}

module "instance_template" {
  source      = "../compute_engine/instance_template"
  project_id  = var.project
  description = "Secure Swarm zone template"
  service_account = {
    email  = local.service_account_email
    scopes = var.service_account_scopes
  }
  enable_shielded_vm   = true
  name_prefix          = var.name
  zones                = var.zones
  machine_type         = var.machine_type
  source_image         = var.source_image
  source_image_family  = var.source_image_family
  source_image_project = var.source_image_project
  subnetwork_project   = var.project
  network              = var.network
  additional_disks = [{
    boot         = false
    auto_delete  = false
    device_name  = module.secure_disk.disk_name
    disk_name    = module.secure_disk.disk_name
    disk_size_gb = var.disk_size
    disk_type    = "pd-standard"
    mode         = "READ_WRITE"
  }]
}

module "stateful_instance_group" {
  source             = "../compute_engine/managed_instance_group"
  description        = "Secure Swarm zone managed instance group"
  base_instance_name = var.name
  disk_name          = module.secure_disk.disk_name
  initial_delay      = 180
  instance_template  = module.instance_template.id
  name               = var.name
  project            = var.project
  region             = var.region
  stateful_disks = [{
    device_name = module.secure_disk.disk_name
    delete_rule = "NEVER"
  }]
  zones = var.zones
}

