variable "default_geo_location" {
  type = "string"
  description = "default geographical location to restrict all resources to unless overridden"
}

variable "default_manage_keys_groups" {
  type = "list"
  default = []
}

variable "default_manage_keys_roles" {
  type = "list"
  default = []
}

variable "default_restrict_resource_location_groups" {
  type = "list"
  default = []
}

variable "default_restrict_resource_location_roles" {
  type = "list"
  default = []
}
