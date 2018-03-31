resource "aws_vpc" "aws_vpc" {
  cidr_block        = "${var.cidr_block}"
  instance_tenancy  = "dedicated"
  tags              = "${var.tags}"
}