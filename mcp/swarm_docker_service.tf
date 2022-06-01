resource "docker_service" "self" {
  for_each = local.docker_service
  name     = lookup(each.value.docker_service, "name", null)
  dynamic "task_spec" {
    for_each = lookup(each.value.docker_service, "task_spec", null) == null ? {} : { task_spec : each.value.docker_service.task_spec }
    content {
      dynamic "container_spec" {
        for_each = lookup(task_spec.value, "container_spec", null) == null ? {} : { container_spec : task_spec.value.container_spec }
        content {
          image   = lookup(container_spec.value, "image", null)
          args    = lookup(container_spec.value, "args", null)
          command = lookup(container_spec.value, "command", null)
          dynamic "configs" {
            for_each = lookup(container_spec.value, "configs", null) == null ? {} : { configs : container_spec.value.configs }
            content {
              config_id   = lookup(configs.value, "config_id", null)
              file_name   = lookup(configs.value, "file_name", null)
              config_name = lookup(configs.value, "config_name", null)
              file_gid    = lookup(configs.value, "file_gid", null)
              file_mode   = lookup(configs.value, "file_mode", null)
              file_uid    = lookup(configs.value, "file_uid", null)
            }
          }
          dir = lookup(container_spec.value, "dir", null)
          dynamic "dns_config" {
            for_each = lookup(container_spec.value, "dns_config", null) == null ? {} : { dns_config : container_spec.value.dns_config }
            content {
              nameservers = lookup(dns_config.value, "nameservers", null)
              options     = lookup(dns_config.value, "options", null)
              search      = lookup(dns_config.value, "search", null)
            }
          }
          env    = lookup(container_spec.value, "env", {})
          groups = lookup(container_spec.value, "groups", null)
          dynamic "healthcheck" {
            for_each = lookup(container_spec.value, "healthcheck", null) == null ? {} : { healthcheck : container_spec.value.healthcheck }
            content {
              interval     = lookup(healthcheck.value, "interval", null)
              test      = lookup(healthcheck.value, "test", null)
              retries      = lookup(healthcheck.value, "retries", null)
              start_period = lookup(healthcheck.value, "start_period", null)
              timeout      = lookup(healthcheck.value, "timeout", null)
            }
          }
          hostname = lookup(container_spec.value, "hostname", null)
          dynamic "hosts" {
            for_each = lookup(container_spec.value, "hosts", null) == null ? {} : { hosts : container_spec.value.hosts }
            content {
              host     = lookup(hosts.value, "host", null)
              ip      = lookup(hosts.value, "ip", null)
            }
          }
          isolation = lookup(container_spec.value, "isolation", null)
          dynamic "labels" {
            for_each = lookup(container_spec.value, "labels", null) == null ? {} : { labels : container_spec.value.labels }
            content {
              label     = lookup(labels.value, "label", null)
              value      = lookup(labels.value, "value", null)
            }
          }
          dynamic "mounts" {
            for_each = lookup(container_spec.value, "mounts", null) == null ? {} : { mounts : container_spec.value.mounts }
            content {
              target     = lookup(mounts.value, "target", null)
              type       = lookup(mounts.value, "type", null)
              dynamic "bind_options" {
                for_each = lookup(mounts.value, "bind_options", null) == null ? {} : { bind_options : mounts.value.bind_options }
                content {
                  propagation = lookup(bind_options.value, "propagation", null)
                }   
              }
              read_only    = lookup(mounts.value, "read_only", null)
              source       = lookup(mounts.value, "source", null)
              dynamic "tmpfs_options" {
                for_each = lookup(mounts.value, "tmpfs_options", null) == null ? {} : { tmpfs_options : mounts.value.tmpfs_options }
                content {
                  mode = lookup(tmpfs_options.value, "mode", null)
                  size_bytes = lookup(tmpfs_options.value, "size_bytes", null)
                }   
              }
              dynamic "volume_options" {
                for_each = lookup(mounts.value, "volume_options", null) == null ? {} : { volume_options : mounts.value.volume_options }
                content {
                  driver_name = lookup(volume_options.value, "driver_name", null)
                  driver_options = lookup(volume_options.value, "driver_options", null)
                  no_copy = lookup(volume_options.value, "no_copy", null)
                  dynamic "labels" {
                    for_each = lookup(volume_options.value, "labels", null) == null ? {} : { labels :volume_options.value.labels }
                    content {
                      label = lookup(labels.value, "label", null)
                      value = lookup(labels.value, "value", null)
                }   
              }
                }   
              }
            }
          }
          dynamic "privileges" {
            for_each = lookup(container_spec.value, "privileges", null) == null ? {} : { privileges : container_spec.value.privileges }
            content {
              dynamic "credential_spec" {
                for_each = lookup(privileges.value, "credential_spec", null) == null ? {} : { credential_spec : privileges.value.credential_spec }
                content {
                  file    = lookup(credential_spec.value, "file", null)
                  registry = lookup(credential_spec.value, "registry", {})
                }
              }
              dynamic "se_linux_context" {
                for_each = lookup(privileges.value, "se_linux_context", null) == null ? {} : { se_linux_context : privileges.value.se_linux_context }
                content {
                  disable    = lookup(se_linux_context.value, "disable", null)
                  level = lookup(se_linux_context.value, "level", null)
                  role = lookup(se_linux_context.value, "role", null)
                  type = lookup(se_linux_context.value, "type", null)
                  user = lookup(se_linux_context.value, "user", null)
                }
              }
            }
          }
          read_only = lookup(container_spec.value, "read_only", null)
          dynamic "labels" {
            for_each = lookup(container_spec.value, "labels", null) == null ? {} : { labels : container_spec.value.labels }
            content {
              label     = lookup(labels.value, "label", null)
              value      = lookup(labels.value, "value", null)
            }
          }
        }
      }
      force_update = lookup(task_spec.value, "force_update", null)
      dynamic "log_driver" {
        for_each = lookup(task_spec.value, "log_driver", null) == null ? {} : { log_driver : task_spec.value.log_driver }
        content {
          name    = lookup(log_driver.value, "name", null)
          options = lookup(log_driver.value, "options", {})
        }
      }
      networks = lookup(task_spec.value, "networks", null)
      dynamic "placement" {
        for_each = lookup(task_spec.value, "placement", null) == null ? {} : { placement : task_spec.value.placement }
        content {
          constraints  = lookup(placement.value, "constraints", null)
          max_replicas = lookup(placement.value, "max_replicas", null)
          dynamic "platforms" {
            for_each = lookup(placement.value, "platforms", null) == null ? {} : { platforms : placement.value.platforms }
            content {
              architecture = lookup(platforms.value, "architecture", null)
              os           = lookup(platforms.value, "os", null)
            }
          }
          prefs = lookup(placement.value, "prefs", null)
        }
      }
      dynamic "resources" {
        for_each = lookup(task_spec.value, "resources", null) == null ? {} : { resources : task_spec.value.resources }
        content {
          dynamic "limits" {
            for_each = lookup(resources.value, "limits", null) == null ? {} : { limits : resources.value.limits }
            content {
              memory_bytes = lookup(limits.value, "memory_bytes", null)
              nano_cpus    = lookup(limits.value, "nano_cpus", null)
            }
          }
          dynamic "reservation" {
            for_each = lookup(resources.value, "reservation", null) == null ? {} : { reservation : resources.value.reservation }
            content {
              memory_bytes = lookup(reservation.value, "memory_bytes", null)
              nano_cpus    = lookup(reservation.value, "nano_cpus", null)
              dynamic "generic_resources" {
                for_each = lookup(reservation.value, "generic_resources", null) == null ? {} : { generic_resources : reservation.value.generic_resources }
                content {
                  discrete_resources_spec = lookup(generic_resources.value, "discrete_resources_spec", null)
                  named_resources_spec    = lookup(generic_resources.value, "named_resources_spec", null)
                }
              }
            }
          }
        }
      }
      dynamic "restart_policy" {
        for_each = lookup(task_spec.value, "restart_policy", null) == null ? {} : { restart_policy : task_spec.value.restart_policy }
        content {
          condition    = lookup(restart_policy.value, "condition", null)
          delay        = lookup(restart_policy.value, "delay", null)
          max_attempts = lookup(restart_policy.value, "max_attempts", null)
          window       = lookup(restart_policy.value, "window", null)
        }
      }
      runtime = lookup(task_spec.value, "runtime", null)

    }
  }
}
