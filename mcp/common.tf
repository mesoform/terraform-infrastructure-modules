locals {
  common_files = fileset(path.module, "../**/**")
  common = {
    for common_file in local.common_files:
      split("/", common_file)[1] => yamldecode(file(common_file))
  }
}

