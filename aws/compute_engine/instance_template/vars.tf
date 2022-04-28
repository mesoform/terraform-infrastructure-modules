variable "ami_owner" {
  description = "AMI owner"
  type = string
  default     = "099720109477"
}

variable "ami_id" {
  description = "AMI id"
  type = string
  default     = "ami-0d12a58ec39ffb406"
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