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
  key_name            = aws_key_pair.instance_key.key_name
  public_subnet_id    = module.vpc.public_subnet_id
  private_subnet_id   = module.vpc.private_subnet_id
  db_subnet_id        = module.vpc.db_subnet_id
}

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

data "aws_instance" "self" {
  filter {
    name   = "tag:Name"
    values = ["swarm_node"]
  }
  depends_on = [
    aws_autoscaling_group.example,
  ]
}

data "aws_ebs_volume" "ebs_volume" {
  most_recent = true

  filter {
    name   = "tag:Name"
    values = ["persistent_volume"]
  }
}


resource "aws_volume_attachment" "ebs_att" {
  device_name = "/dev/sdh"
  volume_id   = data.aws_ebs_volume.ebs_volume.id
  instance_id = data.aws_instance.self.id
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

resource "aws_key_pair" "instance_key" {
  key_name   = "mesoform_key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDH/L16ACajBGASbwvPw/9kgCchE2WsPCmXR44cG4yqojPj3gSNOkxCwAcbbSraru2UxPSZzlb08WFRYz2Ewrxs1hD7A7v9CSA2P1Kxc5mRkuH/p0svIwaq/pUOvNWdEREnvVELScRhjUqtPYil3XOXQBrNNR8EHeiJ4bt04oQB3sr71HFtm65hbB3OnGm5Zymgq3vREKCaac2VoUQJ+Iw4E81sMrxS9Y6kAL+iNVZfcJYmANc+QJyyAMIZRTtjoTKiDeQIpSPX5M7lG7MV26bXIoysY1ISTu9ZB6kihYyiAXGAN1asLU16+9g1HzkHUJAVtEvOeBOQt2lAaHD6RAjkjrCyDCmEgczMT6x+P5ZiX6ffN4B1BTQArOxVXPGWP73hmxkiztRbtyKQincy9BlGyNxvUSnnrk2X9VjnQDRlgww7Qe7aEpjB0PHcnjQW6/FTRu7NR8K6t+VDV4XnsWSNekraI6hAIuXJbdiQaTc3H1CsRRLVNE2Spq7E5vvbGds= dmitrogavrichuk@iMac-Dmitro.local"
}