variable gcp_ae_yml {
  description = "path to YAML file containing configuration for GAE Applications/Services"
  type = string
}
variable user_project_config_yml {
  type = string
  default = "resources/project.yml"
}