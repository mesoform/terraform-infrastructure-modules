##################
# Security group #
###s###############

resource "aws_security_group" "main_sg" {
  name        = "${var.common_tags["Project"]}_security_group"
  description = "Allow inbound traffic"
  vpc_id      = aws_vpc.main.id
  tags = merge(
    { Name = "${var.common_tags["Project"]}_security_group" },
  var.common_tags)

  dynamic "ingress" {
    for_each = var.ports
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  ingress {
    from_port   = 8
    to_port     = 0
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

########################################
# availability zones in current region #
########################################

data "aws_availability_zones" "available" {
}

###########################
# Creating public subnets #
###########################

resource "aws_subnet" "public_subnets" {
  count                   = length(var.public_subnet_cidrs)
  vpc_id                  = aws_vpc.main.id
  cidr_block              = element(var.public_subnet_cidrs, count.index)
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = true
  tags = merge(
    { Name = "${var.common_tags["Project"]}_public_subnet_${count.index + 1}" },
  var.common_tags)
}

###########################
# Creating db subnets     #
###########################

resource "aws_subnet" "db_subnets" {
  count                   = length(var.db_subnet_cidrs)
  vpc_id                  = aws_vpc.main.id
  cidr_block              = element(var.db_subnet_cidrs, count.index)
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = false
  tags = merge(
    { Name = "${var.common_tags["Project"]}_db_subnet_${count.index + 1}" },
  var.common_tags)
}

############################
# Creating private subnets #
############################

resource "aws_subnet" "private_subnets" {
  count                   = length(var.private_subnet_cidrs)
  vpc_id                  = aws_vpc.main.id
  cidr_block              = element(var.private_subnet_cidrs, count.index)
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = false
  tags = merge(
    { Name = "${var.common_tags["Project"]}_private_subnet_${count.index + 1}" },
  var.common_tags)
}

######################
# NAT gateway        #
######################

resource "aws_nat_gateway" "gw" {
  count         = length(aws_subnet.public_subnets[*].id)
  allocation_id = element(aws_eip.nat[*].id, count.index)
  subnet_id     = element(aws_subnet.public_subnets[*].id, count.index)
  #depends_on    = ["aws_internet_gateway.main"]
  tags = merge(
    { Name = "${var.common_tags["Project"]}_NAT_gateway_${count.index + 1}" },
  var.common_tags)
}

######################
# Elastic IP        #
######################

resource "aws_eip" "nat" {
  count = length(aws_subnet.public_subnets[*].id)
  vpc   = true
  tags = merge(
    { Name = "${var.common_tags["Project"]}_EIP_${count.index + 1}" },
  var.common_tags)
}

###################################
# Rout table for internet gateway #
###################################

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }
  tags = merge(
    { Name = "${var.common_tags["Project"]}_internet_route_table" },
  var.common_tags)
}

###################################
# Rout table for NAT gateway      #
###################################

resource "aws_route_table" "nat_rt" {
  count  = length(aws_subnet.private_subnets[*].id)
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = element(aws_nat_gateway.gw[*].id, count.index)
  }
  tags = merge(
    { Name = "${var.common_tags["Project"]}_NAT_route_table_${count.index + 1}" },
  var.common_tags)
}

###################################
# Rout table for local subnets    #
###################################

resource "aws_route_table" "local_rt" {
  vpc_id = aws_vpc.main.id

  tags = merge(
    { Name = "${var.common_tags["Project"]}_local_route_table" },
  var.common_tags)
}

#######################################################
# Internet rout table assotiation with public subnets #
#######################################################

resource "aws_route_table_association" "public_routes" {
  count          = length(aws_subnet.public_subnets[*].id)
  route_table_id = aws_route_table.public_rt.id
  subnet_id      = element(aws_subnet.public_subnets[*].id, count.index)
}

######################################################
# NAT rout table assotiation with private subnets    #
######################################################

resource "aws_route_table_association" "nat_routes" {
  count          = length(aws_subnet.private_subnets[*].id)
  route_table_id = element(aws_route_table.nat_rt[*].id, count.index)
  subnet_id      = element(aws_subnet.private_subnets[*].id, count.index)
}

######################################################
# NAT rout table assotiation with db subnets         #
######################################################

resource "aws_route_table_association" "db_routes" {
  count          = length(aws_subnet.db_subnets[*].id)
  route_table_id = aws_route_table.local_rt.id
  subnet_id      = element(aws_subnet.db_subnets[*].id, count.index)
}

######################
# Creating VPC       #
######################

resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr
  tags = merge(
    { Name = "${var.common_tags["Project"]}_vpc" },
  var.common_tags)
}

######################
# Internrt gateway   #
######################

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id
  tags = merge(
    { Name = "${var.common_tags["Project"]}_internet_gateway" },
  var.common_tags)
}

output "vpc_id_1" {
  value = aws_vpc.main.id
}

#resource "aws_eip" "lb" {
#  instance = "${aws_instance.nandos_mirror[0].id}"
#  vpc      = true
#}
