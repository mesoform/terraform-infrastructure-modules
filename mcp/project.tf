locals {
  project = yamldecode(file(“${path.cwd}/../project.yml”))
}

