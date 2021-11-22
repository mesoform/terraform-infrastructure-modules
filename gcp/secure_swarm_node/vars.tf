variable "name" {
  type    = string
  default = "secure-swarm"
}

variable "project" {
  type        = string
  description = "GCP project"
}

variable "zone"{
  type = string
}

variable "region" {
  type    = string
  default = "europe-west2"
}

variable "labels" {
  type    = map(string)
  default = null
}

variable "tags" {
  type = list(string)
  description = "Tags for instance template"
  default = []
}

//Disk configuration
variable "disk_size" {
  type    = number
  default = 500
}

variable "disk_type" {
  description = "Type of disk to attach to instance, default is standard persistent disk"
  type    = string
  default = "pd-standard"
}

variable "access_config" {
  type = map(list(map(string)))
  default = {}
}
variable "network" {
  type    = string
  default = "default"
}
variable "subnetwork" {
  type    = string
  default = null
}

variable "network_ip" {
  type    = string
  default = null
}
variable "machine_type" {
  type    = string
  default = "n2d-standard-2"
}

variable "version_name" {
  type = string
  default = null
}

variable "source_image" {
  description = "Source disk image. If neither source_image nor source_image_family is specified, defaults to the latest public Debian image."
  default     = ""
}

variable "source_image_family" {
  description = "Source image family. If neither source_image nor source_image_family is specified, defaults to the latest public Debian image."
  default     = "centos-8"
}

variable "source_image_project" {
  description = "Project where the source image comes from. The default project contains images that support Shielded VMs if desired"
  default     = "centos-cloud"
}

variable "service_account_email" {
  type    = string
  default = ""
}

variable "service_account_scopes" {
  type    = set(string)
  default = ["cloud-platform"]
}


variable "health_check" {
  type = set(object({
    name              = string
    initial_delay_sec = number
  }))
  default = []
}

variable "named_ports" {
  type = set(object({
    name = string
    port = number
  }))
  default = []
}

variable security_level {
  type = string
  validation {
    condition = contains(["secure-1", "confidential-1"], var.security_level)
    error_message = "Provided value not of a valid type."
  }
}

variable "update_policy" {
  description = "The rolling update policy. https://www.terraform.io/docs/providers/google/r/compute_region_instance_group_manager.html#rolling_update_policy"
  type = list(object({
    max_surge_fixed              = optional(number)
    max_surge_percent            = optional(number)
    max_unavailable_fixed        = optional(number)
    max_unavailable_percent      = optional(number)
    min_ready_sec                = optional(number)
    minimal_action               = string
    type                         = string
    replacement_method           = optional(string)
  }))
  default = []
}

variable target_size {
  description = "Target Size of the Managed Instance Group"
  default = 0
  validation {
    condition = var.target_size <= 1
    error_message = "Target size cannot be more than 1 for stateful managed instance groups."
  }
}

variable "deployment_version" {
  validation {
    condition = contains(["blue", "green"], var.deployment_version)
    error_message = "Invalid deployment version."
  }
  type = string
}

variable blue_instance_template {
  type = object({
    machine_type = optional(string)
    source_image = optional(string)
    source_image_family = optional(string)
    source_image_project = optional(string)
    network = optional(string)
    subnetwork = optional(string)
    network_ip = optional(map(string))
    access_config = optional(map(list(map(string))))
    security_level = optional(string)
    service_account_scopes = optional(set(string))
  })
  default = {}
}

variable green_instance_template {
  type = object({
    machine_type = optional(string)
    source_image = optional(string)
    source_image_family = optional(string)
    source_image_project = optional(string)
    network = optional(string)
    subnetwork = optional(string)
    network_ip = optional(map(string))
    access_config = optional(map(list(map(string))))
    security_level = optional(string)
    service_account_scopes = optional(set(string))
  })
  default = {}
}

variable data_disk_snapshot_schedule {
  description = "Hourly, Daily or Weekly snapshot schedule, must be 24hour format"
  type = object({
    frequency = string
    start_time = optional(string)
    interval = optional(number)
    weekly_snapshot_schedule = optional(list(object({
      day = string
      start_time = string
    })))
  })

  default = {
    frequency = "daily"
    interval = 1
    start_time = "03:00"
  }

  validation {
    condition = contains(["hourly", "daily", "weekly"], var.data_disk_snapshot_schedule.frequency)
    error_message = "Frequency must be either 'hourly', 'daily', 'weekly'."
  }
}

variable retention_policy {
  description = "Retention Policy Applied to snapshots"
  type = object({
    max_retention_days = number
    on_source_disk_delete = optional(string)
  })
  default = null
}

variable snapshot_properties {
  type = object({
    labels = optional(map(string))
    storage_locations = optional(list(string))
    guest_flush = optional(string)

  })
  default = null
}

variable wait_for_instances {
  description = "Whether to wait for instances to be created before returning"
  type = bool
  default = false
}
