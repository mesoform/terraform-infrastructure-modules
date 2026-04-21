resource "docker_container" "self" {
  for_each = local.docker_container
  name                  = lookup(each.value.docker_container, "name", null)
  image                 = lookup(each.value.docker_container, "image", null)
  attach                = lookup(each.value.docker_container, "attach", null)
  command               = lookup(each.value.docker_container, "command", [])
  cpu_set               = lookup(each.value.docker_container, "cpu_set", null)
  cpu_shares            = lookup(each.value.docker_container, "cpu_shares", null)
  destroy_grace_seconds = lookup(each.value.docker_container, "destroy_grace_seconds", null)
  dns                   = lookup(each.value.docker_container, "dns", [])
  dns_opts              = lookup(each.value.docker_container, "dns_opts", [])
  dns_search            = lookup(each.value.docker_container, "dns_search", [])
  domainname            = lookup(each.value.docker_container, "domainname", null)
  entrypoint            = lookup(each.value.docker_container, "entrypoint", [])
  env                   = lookup(each.value.docker_container, "env", [])
  group_add             = lookup(each.value.docker_container, "group_add", [])
  hostname              = lookup(each.value.docker_container, "hostname", null)
  init                  = lookup(each.value.docker_container, "init", null)
  ipc_mode              = lookup(each.value.docker_container, "ipc_mode", null)
  links                 = lookup(each.value.docker_container, "links", [])
  log_driver            = lookup(each.value.docker_container, "log_driver", null)
  log_opts              = lookup(each.value.docker_container, "log_opts", {})
  logs                  = lookup(each.value.docker_container, "logs", null)
  max_retry_count       = lookup(each.value.docker_container, "max_retry_count", null)
  memory                = lookup(each.value.docker_container, "memory", null)
  memory_swap           = lookup(each.value.docker_container, "memory_swap", null)
  must_run              = lookup(each.value.docker_container, "must_run", null)
  network_alias         = lookup(each.value.docker_container, "network_alias", [])
  network_mode          = lookup(each.value.docker_container, "network_mode", null)
  networks              = lookup(each.value.docker_container, "networks", [])
  pid_mode              = lookup(each.value.docker_container, "pid_mode", null)
  privileged            = lookup(each.value.docker_container, "privileged", null)
  publish_all_ports     = lookup(each.value.docker_container, "publish_all_ports", null)
  read_only             = lookup(each.value.docker_container, "read_only", null)
  remove_volumes        = lookup(each.value.docker_container, "remove_volumes", null)
  restart               = lookup(each.value.docker_container, "restart", null)
  rm                    = lookup(each.value.docker_container, "rm", null)
  security_opts         = lookup(each.value.docker_container, "security_opts", [])
  shm_size              = lookup(each.value.docker_container, "shm_size", null)
  start                 = lookup(each.value.docker_container, "start", null)
  stdin_open            = lookup(each.value.docker_container, "stdin_open", null)
  storage_opts          = lookup(each.value.docker_container, "storage_opts", {})
  sysctls               = lookup(each.value.docker_container, "sysctls", {})
  tmpfs                 = lookup(each.value.docker_container, "tmpfs", {})
  tty                   = lookup(each.value.docker_container, "tty", null)
  user                  = lookup(each.value.docker_container, "user", null)
  userns_mode           = lookup(each.value.docker_container, "userns_mode", null)
  working_dir           = lookup(each.value.docker_container, "working_dir", null)
  dynamic "capabilities" {
    for_each = lookup(each.value.docker_container, "capabilities", null) == null ? {} : { capabilities : each.value.docker_container.capabilities }
    content {
      add  = lookup(capabilities.value, "add", null)
      drop = lookup(capabilities.value, "drop", null)
    }
  }
  dynamic "devices" {
    for_each = lookup(each.value.docker_container, "devices", null) == null ? {} : { devices : each.value.docker_container.devices }
    content {
      host_path      = lookup(devices.value, "host_path", null)
      container_path = lookup(devices.value, "container_path", null)
      permissions    = lookup(devices.value, "permissions", null)
    }
  }
  dynamic "healthcheck" {
    for_each = lookup(each.value.docker_container, "healthcheck", null) == null ? {} : { healthcheck : each.value.docker_container.healthcheck }
    content {
      test         = lookup(healthcheck.value, "test", [])
      interval     = lookup(healthcheck.value, "interval", null)
      retries      = lookup(healthcheck.value, "retries", null)
      start_period = lookup(healthcheck.value, "start_period", null)
      timeout      = lookup(healthcheck.value, "timeout", null)
    }
  }
  dynamic "host" {
    for_each = lookup(each.value.docker_container, "host", null) == null ? {} : { host : each.value.docker_container.host }
    content {
      host = lookup(host.value, "host", null)
      ip   = lookup(host.value, "ip", null)
    }
  }
  dynamic "labels" {
    for_each = lookup(each.value.docker_container, "labels", null) == null ? {} : { labels : each.value.docker_container.labels }
    content {
      label = lookup(labels.value, "label", null)
      value = lookup(labels.value, "value", null)
    }
  }
  dynamic "mounts" {
    for_each = lookup(each.value.docker_container, "mounts", null) == null ? {} : { mounts : each.value.docker_container.mounts }
    content {
      type   = lookup(mounts.value, "type", null)
      target = lookup(mounts.value, "target", null)
      dynamic "bind_options" {
        for_each = lookup(mounts.value, "bind_options", null) == null ? {} : { bind_options : mounts.value.bind.options }
        content {
          propagation = lookup(bind_options.value, "propagation", null)
        }
      }
      read_only = lookup(mounts.value, "read_only", null)
      source    = lookup(mounts.value, "source", null)
      dynamic "tmpfs_options" {
        for_each = lookup(mounts.value, "tmpfs_options", null) == null ? {} : { tmpfs_options : mounts.value.tmpfs_options }
        content {
          mode       = lookup(tmpfs_options.value, "mode", null)
          size_bytes = lookup(tmpfs_options.value, "size_bytes", null)
        }
      }
      dynamic "volume_options" {
        for_each = lookup(mounts.value, "volume_options", null) == null ? {} : { volume_options : mounts.value.volume_options }
        content {
          driver_name    = lookup(volume_options.value, "driver_name", null)
          driver_options = lookup(volume_options.value, "driver_options", {})
          dynamic "labels" {
            for_each = lookup(volume_options.value, "labels", null) == null ? {} : { labels : volume_options.value.labels }
            content {
              label = lookup(labels.value, "label", null)
              value = lookup(labels.value, "value", null)
            }
          }
        }
      }   
    }
  }
  dynamic "networks_advanced" {
    for_each = lookup(each.value.docker_container, "networks_advanced", null) == null ? {} : { networks_advanced : each.value.docker_container.networks_advanced }
    content {
      name         = lookup(networks_advanced.value, "name", null)
      aliases      = lookup(networks_advanced.value, "aliases", [])
      ipv4_address = lookup(networks_advanced.value, "ipv4_address", null)
      ipv6_address = lookup(networks_advanced.value, "ipv6_address", null)
    }
  }
  dynamic "ports" {
    for_each = lookup(each.value.docker_container, "ports", null) == null ? {} : { ports : each.value.docker_container.ports }
    content {
      internal = lookup(ports.value, "internal", null)
      external = lookup(ports.value, "external", null)
      ip       = lookup(ports.value, "ip", null)
      protocol = lookup(ports.value, "protocol", null)
    }
  }
  dynamic "ulimit" {
    for_each = lookup(each.value.docker_container, "ulimit", null) == null ? {} : { ulimit : each.value.docker_container.ulimit }
    content {
      hard = lookup(ulimit.value, "hard", null)
      name = lookup(ulimit.value, "name", null)
      soft = lookup(ulimit.value, "soft", null)
    }
  }
  dynamic "upload" {
    for_each = lookup(each.value.docker_container, "upload", null) == null ? {} : { upload : each.value.docker_container.upload }
    content {
      file           = lookup(upload.value, "file", null)
      content        = lookup(upload.value, "content", null)
      content_base64 = lookup(upload.value, "content_base64", null)
      executable     = lookup(upload.value, "executable", null)
      source         = lookup(upload.value, "source", null)
      source_hash    = lookup(upload.value, "source_hash", null)
    }
  }
  dynamic "volumes" {
    for_each = lookup(each.value.docker_container, "volumes", null) == null ? {} : { volumes : each.value.docker_container.volumes }
    content {
      container_path = lookup(volumes.value, "container_path", null)
      from_container = lookup(volumes.value, "from_container", null)
      host_path      = lookup(volumes.value, "host_path", null)
      read_only      = lookup(volumes.value, "read_only", null)
      volume_name    = lookup(volumes.value, "volume_name", null)
    }
  }  
}
