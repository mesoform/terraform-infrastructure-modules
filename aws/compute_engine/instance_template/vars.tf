variable "ami_owner" {
  description = "AMI owner"
  type = string
  default     = "099720109477"
}

variable "ami_id" {
  description = "AMI id"
  type = string
  default     = "ami-0d12a58ec39ffb406"
  #default     = "ami-085cbb6056e18788f"
  #default     = "ami-0aa06d075f7c18dff"
}

variable "ami_path" {
  description = "AMI path"
  type = string
  default     = "/aws/service/ami-amazon-linux-latest/"
}

variable "ami_name" {
  description = "AMI name"
  type = string
  default     = "ubuntu/images/hvm-ssd/ubuntu-xenial-16.04-amd64-server-*"
}

variable "description" {
  type    = string
  default = null
}

variable "tags" {
  type        = map(string)
  description = "Instance tags, provided as a list"
  default     = {}
}

variable "availability_zone" {
  type        = string
  description = "Region where the instance template should be created."
  default     = null
}

variable "name_prefix" {
  description = "Name prefix for the instance template"
  default     = "default-instance-template"
}

variable "instance_type" {
  description = "Instance type to create"
  default     = "t2.micro"
}

variable "key_name" {
  description = "SSH key name"
  default     = ""
}

variable "vpc_id" {
  description = "VPC id"
  default     = ""
}

variable "security_group_id" {
  default = ""
}

variable "vpc_cidr" {
  default = ""
}

variable "sg_id" {
  default = ""
}

variable "public_subnet_id" {
}

variable "private_subnet_id" {
}

variable "db_subnet_id" {
}