
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
  private_subnet_id   = module.vpc.private_subnet_id
  db_subnet_id        = module.vpc.db_subnet_id
  security_group_id   = module.vpc.sg_id
  image_id            = local.image_id
}

module secure_instance_template_green {
  source = "../compute_engine/instance_template"
  name_prefix         = "${local.name}-green-"
  description         = var.description
  instance_type       = var.blue_instance_template.instance_type == null ? var.instance_type : var.blue_instance_template.instance_type
  tags                = var.common_tags
  availability_zone   = var.availability_zone
  public_subnet_id    = module.vpc.public_subnet_id
  private_subnet_id   = module.vpc.private_subnet_id
  db_subnet_id        = module.vpc.db_subnet_id
  security_group_id   = module.vpc.sg_id
  image_id            = local.image_id
}


resource "aws_autoscaling_group" "self" {
  name                      = local.name
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

# For optional persistent disk

resource "aws_ebs_volume" "persistent_disk" {
  count             = var.stateful_instance_group && var.persistent_disk ? 1 : 0
  availability_zone = var.availability_zone
  size              = var.persistent_disk_size
  encrypted         = var.security_level == "confidential-1" ? true : false
  type              = var.disk_type
  kms_key_id        = var.kms_key_id

  tags = {
    Name        = "${local.name}-data",
    Device_name = var.persistent_device_name
  }
}

# For optional stateful disk

resource "aws_ebs_volume" "stateful_disk" {
  count             = length(local.stateful_boot_disk) == 0 ? 0 :1
  availability_zone = var.availability_zone
  size              = var.stateful_disk_size
  encrypted         = var.security_level == "confidential-1" ? true : false
  type              = var.disk_type

  tags = {
    Name        = "${local.name}-state",
    Device_name = var.stateful_device_name
  } 
}

module "vpc" {
  source               = "../compute_engine/vpc"
  ports                = ["22", "80"]
  public_subnet_cidrs  = ["10.0.10.0/24"]
  private_subnet_cidrs = []
  db_subnet_cidrs      = ["10.0.12.0/24", "10.0.22.0/24", "10.0.32.0/24"]
  access_config        = var.access_config
  region               = var.region
  common_tags          = var.common_tags
}


output local_name {
  value = local.name
}

output green_instance_template {
  value = local.green_instance_template
}

output blue_instance_template {
  value = local.blue_instance_template
}

output boot_disk {
  value = local.stateful_boot_disk
}

