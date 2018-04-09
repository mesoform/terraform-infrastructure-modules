variable "name" {}
variable "private_subnets" {
  type = "list"
  default = []
}
variable "public_subnets" {
  type = "list"
  default = []
}
variable "subnet_tags" {
  type = "map"
  default = {}
}
variable "base_tags" {
  type = "map"
  default = {
    provider = "aws"
    services = "ec2"
  }
}
variable "vpc_id" {}
variable "map_public_ip_on_launch" { default = false }