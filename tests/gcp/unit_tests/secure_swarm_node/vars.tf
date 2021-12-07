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

variable "stateful_boot" {
  default = false
}

variable "stateful_boot_delete_rule" {
  default = "NEVER"
}

variable "name" {
  default = "unit-test"
}

variable "zone" {
  default = "a"
}