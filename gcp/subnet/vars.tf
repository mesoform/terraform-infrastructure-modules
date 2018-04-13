variable "name" {
  type        = "string"
  description = "Subnet name to create on GCP"
}

variable "ip_cidr_range" {
  type        = "list"
  default     = []
}

variable "vpc" {
  type        = "string"
  description = "Direct link to the network"
}
