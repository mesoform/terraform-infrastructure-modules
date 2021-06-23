variable "name" {
  type        = string
  description = "Disk Name"
}

variable "description" {
  type    = string
  default = null
}

variable "guest_os_ft" {
  type        = list(string)
  description = "Guest OS Features"
  default     = []
}

variable "interface" {
  type        = string
  description = "Disk interface"
  default     = null
}

variable "size" {
  type        = number
  description = "Size of disk"
  default     = null
}

variable "zones" {
  type    = set(string)
  default = null
}

variable "project" {
  type    = string
  default = null
}
variable "region" {
  type    = string
  default = "europe-west2"
}

variable "physical_block_size_bytes" {
  type    = number
  default = null
}

variable "type" {
  type    = string
  default = null
}

variable "image" {
  type    = string
  default = null
}

variable "resource_policies" {
  type    = list(string)
  default = null
}

variable "provisioned_iops" {
  type    = number
  default = null
}

variable "labels" {
  type    = map(string)
  default = {}
}

variable "snapshot" {
  type    = string
  default = null
}

variable "source_image_encryption_key" {
  type    = map(string)
  default = {}
}

variable "disk_encryption_key" {
  type    = map(string)
  default = {}
}

variable "source_snapshot_encryption_key" {
  type    = map(string)
  default = {}
}
