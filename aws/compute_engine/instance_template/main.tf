####################
# Instance Template
####################

resource "aws_launch_template" "self" {
  name_prefix         = var.name_prefix
  description         = var.description
  instance_type       = var.instance_type
  tags                = var.tags
  user_data           = filebase64("../compute_engine/instance_template/user_data/attach.sh")
  image_id            = var.image_id
  placement {
    availability_zone = var.availability_zone
  }
  iam_instance_profile {
    name = aws_iam_instance_profile.self.name
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
  #public_key = file("../compute_engine/instance_template/ssh/key.pub")
  public_key = file(var.key_path)
}

resource "aws_iam_instance_profile" "self" {
  name = "test_profile"
  role = "OrganizationAccountAccessRole"
}
