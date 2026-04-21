resource "docker_image" "self" {
  for_each      = local.docker_image
  name          = lookup(each.value.docker_image, "name", null)
  force_remove  = lookup(each.value.docker_image, "force_remove", null)
  keep_locally  = lookup(each.value.docker_image, "keep_locally", null)
  pull_trigger  = lookup(each.value.docker_image, "pull_trigger", null)
  pull_triggers = lookup(each.value.docker_image, "pull_triggers", null)
  dynamic "build" {
    for_each = lookup(each.value.docker_image, "build", null) == null ? {} : { build : each.value.docker_image.build }
    content {
      path         = lookup(build.value, "path", null)
      build_arg    = lookup(build.value, "build_arg", {})
      dockerfile   = lookup(build.value, "dockerfile", null)
      force_remove = lookup(build.value, "force_remove", null)
      label        = lookup(build.value, "label", null)
      no_cache     = lookup(build.value, "no_cache", null)
      remove       = lookup(build.value, "remove", null)
      tag          = lookup(build.value, "tag", null)
      target       = lookup(build.value, "target", null)
    }
  } 
}
