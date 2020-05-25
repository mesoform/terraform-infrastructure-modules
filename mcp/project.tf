locals {
  user_project_config_yml = file("${path.cwd}/../project.yml")
  project = yamldecode(local.user_project_config_yml)
}

