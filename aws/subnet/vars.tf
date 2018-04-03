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
    services = [
    "ec2",
    "s3",
    "sqs",
    "sns"]
  }
}
variable "vpc_id" {}
variable "map_public_ip_on_launch" { default = false }