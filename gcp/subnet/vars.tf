variable "name" {
  type        = "string"
  description = "Subnet name to create on GCP"
}

variable "private_subnets" {
  type = "list"
  default = []
}
variable "public_subnets" {
  type = "list"
  default = []
}

variable "vpc" {
  type        = "string"
  description = "Direct link to the network"
}

