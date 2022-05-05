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
  default = ["10.0.11.0/24", "10.0.21.0/24"]
}

variable "db_subnet_cidrs" {
  type    = list
  default = ["10.0.12.0/24", "10.0.22.0/24"]
}

variable "common_tags" {
  type = map
}

variable "region" {

}
