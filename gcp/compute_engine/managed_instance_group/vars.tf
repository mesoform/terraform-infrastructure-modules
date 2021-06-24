variable "project" {
  type = string
}

variable "region" {
  type = string
}

variable "zones" {
  type = set(string)
}

variable "version_name" {
  type    = string
  default = null
}

variable "description" {
  type    = string
  default = null
}

variable "disk_name" {}

variable "base_instance_name" {
  type = string
}

variable "name" {
  type = string
}

variable "auto_healing_policies" {
  type = set(object({
    health_check      = string
    initial_delay_sec = number
  }))
  default = []
}

variable "initial_delay" {
  type = number
}

variable "instance_template" {
}

variable "named_ports" {
  type = list(object({
    name = string
    port = number
  }))
  default = []
}

variable "stateful_disks" {
  description = "Disks created on the instances that will be preserved on instance delete. https://cloud.google.com/compute/docs/instance-groups/configuring-stateful-disks-in-migs"
  type = list(object({
    device_name = map(string)
    delete_rule = string
  }))
}

variable "update_policy" {
  description = "The rolling update policy. https://www.terraform.io/docs/providers/google/r/compute_region_instance_group_manager.html#rolling_update_policy"
  type = list(object({
    max_surge_fixed              = number
    instance_redistribution_type = string
    max_surge_percent            = number
    max_unavailable_fixed        = number
    max_unavailable_percent      = number
    min_ready_sec                = number
    minimal_action               = string
    type                         = string
  }))
  default = []
}

variable "target_size" {
  type    = number
  default = 1
}