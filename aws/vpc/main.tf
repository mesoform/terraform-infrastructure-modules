resource "aws_vpc" "self" {
  cidr_block        = "${var.cidr_block}"
  instance_tenancy  = "${var.instance_tenancy}"
  tags              = "${merge(var.base_tags, var.vpc_tags, map("name", var.name))}"
}