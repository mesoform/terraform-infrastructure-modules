

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

variable "image_id" {
}