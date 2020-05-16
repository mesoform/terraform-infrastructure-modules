locals {
  common_files = fileset(path.root, "../**/common.yml")
  common = {
    for common_file in local.common_files:
      split("/", common_file)[1] => yamldecode(file(common_file))
      if split("/", common_file)[1] != "terraform"
  }
}

