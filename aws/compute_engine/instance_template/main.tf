
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
  user_data           = filebase64("../start.sh")
  image_id            = local.image_id
  placement {
    availability_zone = var.availability_zone
  }
  
  block_device_mappings {
    device_name = "/dev/sda1"
    ebs {
      volume_size           = 20
      delete_on_termination = false
      encrypted             = true
  }
  
}
}