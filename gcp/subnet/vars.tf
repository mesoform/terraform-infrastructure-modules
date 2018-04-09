variable "name" {
  type        = "string"
  description = "Subnet name to create on GCP"
}

variable "ip_cidr_range" {
  type        = "list"
  default = []
  description = "IP range to book"
}

variable "vpc" {
  type        = "string"
  description = "Direct link to the network"
}

variable "public_api_access_subnets" {
  type = "list"
  default = []
}

variable "private_api_access_subnets" {
  type = "list"
  default = []
}