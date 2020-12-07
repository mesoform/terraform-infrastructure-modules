locals {
  user_project_config_yml = file(var.user_project_config_yml)
  project                 = yamldecode(local.user_project_config_yml)
}
