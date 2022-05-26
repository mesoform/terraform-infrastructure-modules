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

variable "security_group_id" {
  default = ""
}

variable "public_subnet_id" {
}

variable "image_id" {
}

variable "key_name" {
  description = "SSH key pair name"
}

variable "key_path" {
  description = "Path to SSH key"
}