variable "name" {
  type        = "string"
  description = "Subnet name to create on GCP"
}

variable "ip_cidr_range" {
  type        = "string"
  description = "IP range to book"
}

variable "vpc" {
  type        = "string"
  description = "Direct link to the network"
}

variable "gcp_api_public_access_subnets" {
  type = "list"
  default = []
}

variable "gcp_api_private_access_subnets" {
  type = "list"
  default = []
}