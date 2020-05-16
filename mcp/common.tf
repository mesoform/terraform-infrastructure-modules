locals {
  common_files = fileset(path.root, "../**/common.yml")
  common = {
    for common_file in local.common_files:
      basename(dirname(common_file)) => yamldecode(file(common_file))
      if !contains(split("/", common_file), "terraform")
  }
}

