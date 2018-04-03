variable "name" {}
variable "cidr_block" {}
variable "vpc_tags" {
  type = "map"
  default = {}
}
variable "instance_tenancy" {default = "shared"}
variable "base_tags" {
  type = "map"
  default = {
    provider = "aws"
    services = "ec2"
  }
}