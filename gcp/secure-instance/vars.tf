variable "name" {
  type    = string
  default = "secure-swarm"
}

variable "project" {
  type        = string
  description = "GCP project"
}

variable "region" {
  type    = string
  default = "europe-west2"
}

variable "zones" {
  type    = set(string)
  default = ["a", "b", "c"]
}

variable "labels" {
  type    = map(string)
  default = null
}


//Disk configuration
variable "disk_size" {
  type    = number
  default = 500
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
  default     = "centos-8-v20210609"
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

variable "service_account" {
  type = object({
    email  = string
    scopes = set(string)
  })
  default = { email : "terraform@test-secure-swarm.iam.gserviceaccount.com", scopes : ["Cloud Platform"] }
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


