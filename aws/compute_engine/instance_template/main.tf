
#########
# Locals
#########

locals {
  image_id = var.ami_id == "" ? data.aws_ami.ami.id : var.ami_id
}

###############
# Data Sources
###############

data "aws_ami" "ami" {
  owners = [var.ami_owner]
  most_recent = true

  filter {
    name   = "name"
    values = ["${var.ami_name}"]
  }
}

####################
# Instance Template
####################

resource "aws_launch_template" "self" {
  name_prefix         = var.name_prefix
  description         = var.description
  instance_type       = var.instance_type
  tags                = var.tags
  user_data           = filebase64("../compute_engine/instance_template/user_data/attach.sh")
  image_id            = local.image_id
  placement {
    availability_zone = var.availability_zone
  }

  key_name = aws_key_pair.instance_key.key_name

  block_device_mappings {
    device_name = "/dev/sda1"
    ebs {
      volume_size           = 8
      delete_on_termination = true
      encrypted             = false
  }
  }

  network_interfaces {
    subnet_id       = var.public_subnet_id[0]
    security_groups = [var.security_group_id,]
  }
  
  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "swarm_node"
    }
  }
}
resource "aws_key_pair" "instance_key" {
  key_name   = "${var.tags["Project"]}_key}"
  public_key = file("../compute_engine/instance_template/ssh/key.pub")
}
