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
  default = null
}

variable "stateful_instance_group" {
  description = "Whether the MIG should be stateful (true) or not (false)"
  type = bool
  default = true
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

variable "persistent_disk" {
  type = bool
  description = "Whether to attach a persistent disk to the instance (default true)"
  default = true
}

variable "disk_size" {
  type    = number
  description = "Size of the persistent disk in GB"
  default = 500
}

variable "disk_type" {
  description = "Type of persistent disk to attach to instance, default is standard persistent disk"
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
  description = "List of access configurations, i.e. IPs via which the VM instance can be accessed via the Internet."
  type = list(map(string))
  default = []
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

variable "boot_disk_size" {
  description = "Size of the boot disk in GB"
  type = number
  default = 10
}

variable "boot_device_name" {
  description = "Device name for the boot disk"
  type = string
  default     = null
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

variable "instance_template_description" {
  type = string
  default = "Secure Swarm Node template"
}

variable blue_instance_template {
  type = object({
    machine_type = optional(string)
    source_image = optional(string)
    source_image_family = optional(string)
    source_image_project = optional(string)
    network = optional(string)
    subnetwork = optional(string)
    network_ip = optional(string)
    access_config = optional(list(map(string)))
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
    network_ip = optional(string)
    access_config = optional(list(map(string)))
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
  description = "The update policy for zonal instance group"
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

variable "regional_update_policy" {
  description = "The update policy for regional instance group"
  type = list(object({
    instance_redistribution_type = optional(string)
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
}

variable "deployment_version" {
  validation {
    condition = contains(["blue", "green"], var.deployment_version)
    error_message = "Invalid deployment version."
  }
  type = string
  default = "green"
}

variable wait_for_instances {
  description = "Whether to wait for instances to be created before returning"
  type = bool
  default = false
}

