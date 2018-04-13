variable "name" {
  type        = "string"
  description = "Subnet name to create on GCP"
}

variable "external_ip_cidr_range" {
  type        = "list"
  default     = []
}

variable "underlay_ip_cidr_range" {
  type        = "list"
  default     = []
}

variable "vpc" {
  type        = "string"
  description = "Direct link to the network"
}
