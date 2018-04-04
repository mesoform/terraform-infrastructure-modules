resource "aws_subnet" "external" {
  count = "${length(var.public_subnets) > 0 ? length(var.public_subnets) : 0}"

  vpc_id                  = "${var.vpc_id}"
  cidr_block              = "${var.public_subnets[count.index]}"
  map_public_ip_on_launch = true

  tags = "${merge(var.base_tags, var.subnet_tags, map("name", format("aws-subnet-%s-%s", var.name, count.index)))}"
}

#################
# Private subnet
#################
resource "aws_subnet" "underlay" {
  count = "${length(var.private_subnets) > 0 ? length(var.private_subnets) : 0}"

  vpc_id            = "${var.vpc_id}"
  cidr_block        = "${var.private_subnets[count.index]}"

  tags = "${merge(var.base_tags, var.subnet_tags, map("name", format("aws-subnet-%s-%s", var.name, count.index)))}"
}