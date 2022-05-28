resource "docker_registry_image" "self" {
  for_each             = local.docker_registry_image
  name                 = lookup(each.value.docker_registry_image, "name", null)
  insecure_skip_verify = lookup(each.value.docker_registry_image, "insecure_skip_verify", null)
  keep_remotely        = lookup(each.value.docker_registry_image, "keep_remotely", null)
  dynamic "build" {
    for_each = lookup(each.value.docker_registry_image, "build", null) == null ? {} : { build : each.value.docker_registry_image.build }
    content {
      context = lookup(build.value, "context", null)
      dynamic "auth_config" {
        for_each = lookup(build.value, "auth_config", null) == null ? {} : { auth_config : build.value.auth_config }
        content {
          host_name      = lookup(auth_config.value, "host_name", null)
          auth           = lookup(auth_config.value, "auth", null)
          email          = lookup(auth_config.value, "email", null)
          identity_token = lookup(auth_config.value, "identity_token", null)
          password       = lookup(auth_config.value, "password", null)
          registry_token = lookup(auth_config.value, "registry_token", null)
          server_address = lookup(auth_config.value, "server_address", null)
          user_name      = lookup(auth_config.value, "user_name", null)
        }
      }
      build_args = lookup(build.value, "build_args", {})
      build_id   = lookup(build.value, "build_id", null)
    }
  }
}
