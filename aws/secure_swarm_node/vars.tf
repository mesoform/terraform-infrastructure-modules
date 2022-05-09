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
  default     = "us-east-1a"
}

variable "region" {
  default = "us-east-1"
}


variable "persistent_disk_size"{
  description = "Data disk size"
  default = 20
}

variable "stateful_disk_size" {
  description = "Stateful disk size"
  default = 20
}

variable "name" {
  description = "instance name"
  default = "swarm_node"
}

variable "name_prefix" {
  description = "Name prefix for the instance template"
  default     = "default-instance-template"
}


variable "key_name" {
  description = "SSH key name"
  default     = ""
}

variable "common_tags" {
  type = map(string)
  default = {
    Project     = "mesoform"
    Environment = "blue"
  }
}

variable instance_type {
  description = "Instance type"
  default = "t2.large"
}

variable disk_type {
  default = "gp2"
}

variable blue_instance_template {
  type = object({
    instance_type = optional(string)
    source_image = optional(string)
    #source_image_family = optional(string)
    #source_image_project = optional(string)
    #network = optional(string)
    #subnetwork = optional(string)
    #network_ip = optional(string)
    #access_config = optional(list(map(string)))
    security_level = optional(string)
    service_account_scopes = optional(set(string))
  })
  default = {}
}

variable green_instance_template {
  type = object({
    instance_type = optional(string)
    source_image = optional(string)
    #source_image_family = optional(string)
    #source_image_project = optional(string)
    #network = optional(string)
    #subnetwork = optional(string)
    #network_ip = optional(string)
    #access_config = optional(list(map(string)))
    security_level = optional(string)
    service_account_scopes = optional(set(string))
  })
  default = {}
}

variable security_level {
  type = string
  validation {
    condition = contains(["secure-1", "confidential-1"], var.security_level)
    error_message = "Provided value not of a valid type."
  }
}

variable kms_key_id {
  description = "The ARN for the KMS encryption key"
  default = ""
}

variable "stateful_instance_group" {
  description = "Whether the ASG should be stateful (true) or not (false)"
  type = bool
  default = true
}

variable "persistent_disk" {
  type = bool
  description = "Whether to attach a persistent disk to the instance (default true)"
  default = true
}

variable "stateful_boot" {
  type = bool
  description = "Whether to have boot disk set to stateful"
  default = true
}

variable "stateful_boot_delete_rule" {
  type = string
  description = "Default is 'ON_PERMANENT_INSTANCE_DELETION', set to 'NEVER' if boot disk should remain after scaling MIG down"
  default = "ON_PERMANENT_INSTANCE_DELETION"
}