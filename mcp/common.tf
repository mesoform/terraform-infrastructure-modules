locals {
  common_files = fileset(path.cwd, "../**/common.yml")
  common = {
    for common_file in local.common_files:
      reverse(split("/", common_file))[1] => yamldecode(file(common_file))
  }
}

