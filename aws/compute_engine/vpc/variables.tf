variable "ports" {
  type    = list
  default = ["80", "22"]
}

variable "vpc_cidr" {
  default = "10.0.0.0/16"
}

variable "public_subnet_cidrs" {
  type    = list
  default = ["10.0.10.0/24", "10.0.20.0/24"]
}

variable "private_subnet_cidrs" {
  type    = list
  default = []
}

variable "common_tags" {
  type = map
}

variable "region" {

}

variable "access_config" {
  description = "List of access configurations, i.e. IPs via which the VM instance can be accessed via the Internet."
  type = list(string)
  default = []
}

