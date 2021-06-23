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

variable "disk_size" {
  type    = number
  default = 500
}

variable "labels" {
  type    = map(string)
  default = null
}

variable "network" {
  type    = string
  default = "default"
}
variable "subnetwork" {
  type    = string
  default = null
}
variable "machine_type" {
  type    = string
  default = "n2d-standard-2"
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
  default = ["Cloud Platform"]
}

variable "service_account" {
  type = object({
    email  = string
    scopes = set(string)
  })
  default = { email : "terraform@test-secure-swarm.iam.gserviceaccount.com", scopes : ["Cloud Platform"] }
}

variable "health_check_config" {
  description = "Health check to determine whether instances are responsive and able to do work"
  type = set(object({
    type                = string
    initial_delay_sec   = number
    check_interval_sec  = number
    healthy_threshold   = number
    timeout_sec         = number
    unhealthy_threshold = number
    response            = string
    proxy_header        = string
    port                = number
    request             = string
    request_path        = string
    host                = string
  }))
  default = [{
    type                = "https"
    initial_delay_sec   = 30
    check_interval_sec  = 30
    healthy_threshold   = 1
    timeout_sec         = 10
    unhealthy_threshold = 5
    response            = ""
    proxy_header        = "NONE"
    port                = 80
    request             = ""
    request_path        = "/"
    host                = ""
  }]
}

variable "health_check_names" {
  type    = set(string)
  default = []
}

