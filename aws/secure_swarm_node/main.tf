####################
# AWS Launch Template
####################

module secure_instance_template_blue {
  source = "../compute_engine/instance_template"
  name_prefix         = "test_prefix"
  description         = "description"
  instance_type       = "t2.large"
  tags                = var.common_tags
  availability_zone   = "us-east-1a"
  public_subnet_id    = module.vpc.public_subnet_id
  private_subnet_id   = module.vpc.private_subnet_id
  db_subnet_id        = module.vpc.db_subnet_id
  security_group_id   = module.vpc.sg_id
}

#module "iam" {
#  source      = "../compute_engine/iam"
#  common_tags = var.common_tags
#}

resource "aws_autoscaling_group" "example" {
  name               = "test"
  availability_zones = ["us-east-1a"]
  health_check_grace_period = 300
  force_delete              = true
  desired_capacity   = 1
  max_size           = 1
  min_size           = 1

  launch_template {
    id      = module.secure_instance_template_blue.launch_template_id
    version = module.secure_instance_template_blue.launch_template_version
  }

  tags = [
      {
        "key"                 = "interpolation1"
        "value"               = "value3"
        "propagate_at_launch" = true
      },
      {
        "key"                 = "interpolation2"
        "value"               = "value4"
        "propagate_at_launch" = true
      },
    ]

  instance_refresh {
    strategy = "Rolling"
    preferences {
      min_healthy_percentage = 50
    }
    triggers = ["tag"]
  }
}

module "vpc" {
  source               = "../compute_engine/vpc"
  ports                = ["22", "80"]
  public_subnet_cidrs  = ["10.0.10.0/24"]
  private_subnet_cidrs = []
  db_subnet_cidrs      = ["10.0.12.0/24", "10.0.22.0/24", "10.0.32.0/24"]
  region               = var.region
  common_tags          = var.common_tags
}

