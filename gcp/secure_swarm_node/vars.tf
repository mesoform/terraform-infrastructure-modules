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

variable "metadata" {
  type = map(string)
  description = "Key value pairs for instance metadata"
  default = {}
}

//Disk configuration
variable "stateful_boot" {
  type = bool
  description = "Whether to have boot disk set to stateful"
  default = false
}

variable "stateful_boot_delete_rule" {
  type = string
  description = "Default is 'ON_PERMANENT_INSTANCE_DELETION', set to 'NEVER' if boot disk should remain after scaling MIG down"
  default = "ON_PERMANENT_INSTANCE_DELETION"
}

variable "disk_size" {
  type    = number
  description = "Size of the persistent disk in GB"
  default = 500
}

variable "disk_type" {
  description = "Type of disk to attach to instance, default is standard persistent disk"
  type    = string
  default = "pd-standard"
}

variable "disk_resource_policies" {
  description = "List of resource policies to attach to persistent disk, in form of short name or id e.g. 'projects/PROJECT/regions/REGION/resourcePolicies/SNAPSHOT_SCHEDULE_NAME'"
  type = list(string)
  default = []
}

//Network configuration
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

variable security_level {
  type = string
  validation {
    condition = contains(["secure-1", "confidential-1"], var.security_level)
    error_message = "Provided value not of a valid type."
  }
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

//Instance group manager vars
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

variable wait_for_instances {
  description = "Whether to wait for instances to be created before returning"
  type = bool
  default = false
}
