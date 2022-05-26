resource time_static self {
  triggers = {
    deployment_version = var.deployment_version
  }
}

module secure_instance_template_blue {
  source = "../compute_engine/instance_template"
  name_prefix         = "${local.name}-blue-"
  description         = var.description
  instance_type       = var.blue_instance_template.instance_type == null ? var.instance_type : var.blue_instance_template.instance_type
  tags                = var.common_tags
  availability_zone   = var.availability_zone
  public_subnet_id    = module.vpc.public_subnet_id
  security_group_id   = module.vpc.sg_id
  image_id            = local.image_id
  key_path            = var.key_path
  key_name            = "${var.common_tags["Project"]}_blue_key"
}

module secure_instance_template_green {
  source = "../compute_engine/instance_template"
  name_prefix         = "${local.name}-green-"
  description         = var.description
  instance_type       = var.blue_instance_template.instance_type == null ? var.instance_type : var.blue_instance_template.instance_type
  tags                = var.common_tags
  availability_zone   = var.availability_zone
  public_subnet_id    = module.vpc.public_subnet_id
  security_group_id   = module.vpc.sg_id
  image_id            = local.image_id
  key_path            = var.key_path
  key_name            = "${var.common_tags["Project"]}_green_key"
}


resource "aws_autoscaling_group" "blue" {
  name                      = "${var.name}-blue"
  availability_zones        = var.asg_az
  desired_capacity          = 1
  max_size                  = 1
  min_size                  = 1

  launch_template {
    id      = module.secure_instance_template_blue.launch_template_id
    version = module.secure_instance_template_blue.launch_template_version
  }
  tags = var.ASG_tags
}

resource "aws_autoscaling_group" "green" {
  name                      = "${var.name}-green"
  availability_zones        = var.asg_az
  desired_capacity          = 1
  max_size                  = 1
  min_size                  = 1

  launch_template {
    id      = module.secure_instance_template_green.launch_template_id
    version = module.secure_instance_template_green.launch_template_version
  }
  tags = var.ASG_tags
}

# For optional persistent disk blue

resource "aws_ebs_volume" "_blue_persistent_disk" {
  count             = var.stateful_instance_group && var.persistent_disk ? 1 : 0
  availability_zone = var.availability_zone
  size              = var.persistent_disk_size
  encrypted         = var.security_level == "confidential-1" ? true : false
  type              = var.disk_type
  kms_key_id        = var.kms_key_id

  tags = {
    Name        = "${local.name}-data-blue",
    Device_name = var.persistent_device_name
  }
}

# For optional stateful disk blue

resource "aws_ebs_volume" "blue_stateful_disk" {
  count             = length(local.stateful_boot_disk) == 0 ? 0 :1
  availability_zone = var.availability_zone
  size              = var.stateful_disk_size
  encrypted         = var.security_level == "confidential-1" ? true : false
  type              = var.disk_type

  tags = {
    Name        = "${local.name}-state-blue",
    Device_name = var.stateful_device_name
  } 
}

# For optional persistent disk green

resource "aws_ebs_volume" "green_persistent_disk" {
  count             = var.stateful_instance_group && var.persistent_disk ? 1 : 0
  availability_zone = var.availability_zone
  size              = var.persistent_disk_size
  encrypted         = var.security_level == "confidential-1" ? true : false
  type              = var.disk_type
  kms_key_id        = var.kms_key_id

  tags = {
    Name        = "${local.name}-data-green",
    Device_name = var.persistent_device_name
  }
}

# For optional stateful disk green

resource "aws_ebs_volume" "green_stateful_disk" {
  count             = length(local.stateful_boot_disk) == 0 ? 0 :1
  availability_zone = var.availability_zone
  size              = var.stateful_disk_size
  encrypted         = var.security_level == "confidential-1" ? true : false
  type              = var.disk_type

  tags = {
    Name        = "${local.name}-state-green",
    Device_name = var.stateful_device_name
  } 
}

module "vpc" {
  source               = "../compute_engine/vpc"
  ports                = ["22", "80"]
  public_subnet_cidrs  = ["10.0.10.0/24"]
  private_subnet_cidrs = []
  access_config        = var.access_config
  region               = var.region
  common_tags          = var.common_tags
}


