variable "blue_instance_template" {
  default = {}
}

variable "green_instance_template" {
  default = {
    security_level = "confidential-1"
  }
}

variable "security_level" {
  default = "secure-2"
}
