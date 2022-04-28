####################
# AWS Launch Template
####################

module secure_instance_template_blue {
  source = "../compute_engine/instance_template"
  name_prefix         = "test_prefix"
  description         = "description"
  instance_type       = "t2.large"
  tags                = {
    name = "test"
  }
  availability_zone   = "us-east-1a"
}

resource "aws_autoscaling_group" "example" {
  count = 1
  name               = "test"
  availability_zones = ["us-east-1a"]
  health_check_grace_period = 300
  force_delete              = true
  desired_capacity   = 3
  max_size           = 6
  min_size           = 2

  launch_template {
    id      = module.secure_instance_template_blue.launch_template_id
    version = module.secure_instance_template_blue.launch_template_version
  }

  tag {
    key                 = "Key"
    value               = "Value"
    propagate_at_launch = true
  }

  instance_refresh {
    strategy = "Rolling"
    preferences {
      min_healthy_percentage = 50
    }
    triggers = ["tag"]
  }
}