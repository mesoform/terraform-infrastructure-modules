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
variable "description" {
  type    = string
  default = null
}
variable "zone" {
  type = string
  default = null
}

variable "project_id" {
  type        = string
  description = "The GCP project ID"
  default     = null
}

variable "name_prefix" {
  description = "Name prefix for the instance template"
  default     = "default-instance-template"
}

variable "machine_type" {
  description = "Machine type to create, e.g. n1-standard-1"
  default     = "n1-standard-1"
}

variable "can_ip_forward" {
  description = "Enable IP forwarding, for NAT instances for example"
  type = bool
  default     = false
}

variable "tags" {
  type        = list(string)
  description = "Network tags, provided as a list"
  default     = []
}

variable "labels" {
  type        = map(string)
  description = "Labels, provided as a map"
  default     = {}
}

variable "node_affinities" {
  type = list(object({
    key = string
    operator = string
    values = list(string)
  }))
  default = []
}

variable "on_host_maintenance" {
  type = string
  default = "MIGRATE"
}

variable "preemptible" {
  type        = bool
  description = "Allow the instance to be preempted"
  default     = false
}

variable "region" {
  type        = string
  description = "Region where the instance template should be created."
  default     = null
}

#######
# disk
#######
variable "source_image" {
  description = "Source disk image. If neither source_image nor source_image_family is specified, defaults to the latest public Debian image."
  type = string
  default     = ""
}

variable "source_image_family" {
  description = "Source image family. If neither source_image nor source_image_family is specified, defaults to the latest public Debian image."
  type = string
  default     = "debian-10"
}

variable "source_image_project" {
  description = "Project where the source image comes from. The default project contains images that support Shielded VMs if desired"
  type = string
  default     = "debian-cloud"
}

variable "disk_size_gb" {
  description = "Boot disk size in GB"
  type = number
  default = 10
}

variable "disk_type" {
  description = "Boot disk type, can be either pd-ssd, local-ssd, or pd-standard"
  type = string
  default     = "pd-standard"
}

variable "disk_interface" {
  description = "Interface for the boot disk. Eiter SCSI (default) or NVME (confidential compute)"
  type = string
  default = "SCSI"
}

variable "auto_delete" {
  description = "Whether or not the boot disk should be auto-deleted"
  default     = true
}

variable "additional_disks" {
  description = "List of maps of additional disks. See https://www.terraform.io/docs/providers/google/r/compute_instance_template.html#disk_name"
  type = list(object({
    auto_delete  = bool
    boot         = bool
    device_name  = optional(string)
    disk_name    = optional(string)
    disk_size_gb = optional(number)
    disk_type    = optional(string)
    interface    = optional(string)
    mode         = optional(string)
    source       = optional(string)
    source_image = optional(string)
    type         = optional(string)
    labels       = optional(map(string))
    resource_policies = optional(list(string))
  }))
  default = []
}

####################
# network_interface
####################
variable "network" {
  description = "The name or self_link of the network to attach this interface to. Use network attribute for Legacy or Auto subnetted networks and subnetwork for custom subnetted networks."
  default     = null
}

variable "subnetwork" {
  description = "The name of the subnetwork to attach this interface to. The subnetwork must exist in the same region this instance will be created in. Either network or subnetwork must be provided."
  default     = null
}

variable "subnetwork_project" {
  description = "The ID of the project in which the subnetwork belongs. If it is not provided, the provider project is used."
  default     = null
}

variable "network_ip" {
  type = string
  default = null
}

###########
# metadata
###########

variable "startup_script" {
  description = "User startup script to run when instances spin up"
  default     = ""
}

variable "metadata" {
  type        = map(string)
  description = "Metadata, provided as a map"
  default     = {}
}

##################
# service_account
##################

variable "service_account" {
  type = object({
    email  = string
    scopes = set(string)
  })
  description = "Service account to attach to the instance. See https://www.terraform.io/docs/providers/google/r/compute_instance_template.html#service_account."
}

###########################
# Shielded VMs
###########################
variable "enable_shielded_vm" {
  default     = false
  description = "Whether to enable the Shielded VM configuration on the instance. Note that the instance image must support Shielded VMs. See https://cloud.google.com/compute/docs/images"
}

variable "shielded_instance_config" {
  description = "Not used unless enable_shielded_vm is true. Shielded VM configuration for the instance."
  type = object({
    enable_secure_boot          = bool
    enable_vtpm                 = bool
    enable_integrity_monitoring = bool
  })

  default = {
    enable_secure_boot          = true
    enable_vtpm                 = true
    enable_integrity_monitoring = true
  }
}

variable security_level {
  type = string
  validation {
    condition = contains(["standard-1", "secure-1", "confidential-1"], var.security_level)
    error_message = "Provided value not of a valid type."
  }
}

###########################
# Public IP
###########################
variable "access_config" {
  description = "Access configurations, i.e. IPs via which the VM instance can be accessed via the Internet."
  type = map(list(map(string)))
  default = {}
}

