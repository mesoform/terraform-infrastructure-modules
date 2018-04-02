resource "aws_subnet" "self" {
  count = "${length(var.public_subnets) > 0 ? length(var.public_subnets) : 0}"

  vpc_id                  = "${var.vpc_id}"
  cidr_block              = "${var.public_subnets[count.index]}"
  availability_zone       = "${element(var.availability_zone, count.index)}"
  map_public_ip_on_launch = "${var.map_public_ip_on_launch}"

  tags = "${merge(var.base_tags, var.subnet_tags, map("name", format("aws-subnet-%s-%s", var.name, element(var.availability_zone, count.index))))}"
}

#################
# Private subnet
#################
resource "aws_subnet" "self" {
  count = "${length(var.private_subnets) > 0 ? length(var.private_subnets) : 0}"

  vpc_id            = "${var.vpc_id}"
  cidr_block        = "${var.private_subnets[count.index]}"
  availability_zone = "${element(var.availability_zone, count.index)}"

  tags = "${merge(var.base_tags, var.subnet_tags, map("name", format("aws-subnet-%s-%s", var.name, element(var.availability_zone, count.index))))}"
}