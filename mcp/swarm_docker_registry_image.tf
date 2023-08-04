resource "docker_registry_image" "self" {
  for_each             = local.docker_registry_image
  name                 = lookup(each.value.docker_registry_image, "name", null)
  insecure_skip_verify = lookup(each.value.docker_registry_image, "insecure_skip_verify", null)
  keep_remotely        = lookup(each.value.docker_registry_image, "keep_remotely", null)
  dynamic "build" {
    for_each = lookup(each.value.docker_registry_image, "build", null) == null ? {} : { build : each.value.docker_registry_image.build }
    content {
      context         = lookup(build.value, "context", null)
      build_args      = lookup(build.value, "build_args", {})
      build_id        = lookup(build.value, "build_id", null)
      cache_from      = lookup(build.value, "cache_from", null)
      cgroup_parent   = lookup(build.value, "cgroup_parent", null)
      cpu_period      = lookup(build.value, "cpu_period", null)
      cpu_quota       = lookup(build.value, "cpu_quota", null)
      cpu_set_cpus    = lookup(build.value, "cpu_set_cpus", null)
      cpu_set_mems    = lookup(build.value, "cpu_set_mems", null)
      cpu_shares      = lookup(build.value, "cpu_shares", null)
      dockerfile      = lookup(build.value, "dockerfile", null)
      extra_hosts     = lookup(build.value, "extra_hosts", null)
      force_remove    = lookup(build.value, "force_remove", null)
      isolation       = lookup(build.value, "isolation", null)
      labels          = lookup(build.value, "labels", null)
      memory          = lookup(build.value, "memory", null)
      memory_swap     = lookup(build.value, "memory_swap", null)
      network_mode    = lookup(build.value, "network_mode", null)
      no_cache        = lookup(build.value, "no_cache", null)
      platform        = lookup(build.value, "platform", null)
      pull_parent     = lookup(build.value, "pull_parent", null)
      remote_context  = lookup(build.value, "remote_context", null)
      remove          = lookup(build.value, "remove", null)
      security_opt    = lookup(build.value, "security_opt", null)
      session_id      = lookup(build.value, "session_id", null)
      shm_size        = lookup(build.value, "shm_size", null)
      squash          = lookup(build.value, "squash", null)
      suppress_output = lookup(build.value, "suppress_output", null)
      target          = lookup(build.value, "target", null)
      version         = lookup(build.value, "version", null)
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
      dynamic "ulimit" {
        for_each = lookup(build.value, "ulimit", null) == null ? {} : { ulimit : build.value.ulimit }
        content {
          hard = lookup(ulimit.value, "hard", null)
          name = lookup(ulimit.value, "name", null)
          soft = lookup(ulimit.value, "soft", null)
        }
      }
    }
  }
}
