variable gcp_ae_yml {
  description = "path to YAML file containing configuration for GAE Applications/Services"
  type = string
  default = "../../gcp_ae.yml"
}
variable user_project_config_yml {
  type = string
  default = "resources/project.yml"
}

variable "gcp_ae_traffic" {
  type = map
  default = null
}

variable gcp_ae_traffic_yml {
  type = string
  default = "resources/gcp_ae_traffic.yml"
}