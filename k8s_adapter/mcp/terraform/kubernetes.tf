locals {
  k8s_services_files = fileset(path.root, "../**/k8s_service.y{a,}ml")
  k8s_services = {
    for kube_file in local.k8s_services_files :
    basename(dirname(kube_file)) => { service : yamldecode(file(kube_file)) }
    if ! contains(split("/", kube_file), "terraform")
  }

  k8s_deployments_files = fileset(path.root, "../**/k8s_deployment.y{a,}ml")
  k8s_deployments = {
    for kube_file in local.k8s_deployments_files :
    basename(dirname(kube_file)) => { deployment : yamldecode(file(kube_file)) }
    if ! contains(split("/", kube_file), "terraform")
  }

  k8s = {
    for app, config in local.k8s_services :
    app => merge(config, lookup(local.k8s_deployments, app, {}))
  }
}

provider "kubernetes" {
  load_config_file = true
}

resource "kubernetes_deployment" "self" {
  for_each         = local.k8s_deployments
  wait_for_rollout = lookup(each.value.deployment, "wait_for_rollout", true)
  metadata {
    annotations   = lookup(each.value.deployment.metadata, "annotations", {})
    generate_name = lookup(each.value.deployment.metadata, "name", null) == null ? lookup(each.value.deployment.metadata, "generate_name", {}) : null
    name          = lookup(each.value.deployment.metadata, "name", null)
    labels        = lookup(each.value.deployment.metadata, "labels", {})
    namespace     = lookup(each.value.deployment.metadata, "namespace", null)
  }
  spec {
    min_ready_seconds         = lookup(each.value.deployment.spec, "min_ready_seconds", null)
    paused                    = lookup(each.value.deployment.spec, "paused", null)
    progress_deadline_seconds = lookup(each.value.deployment.spec, "progress_deadline_seconds", null)
    replicas                  = lookup(each.value.deployment.spec, "replicas", null)
    revision_history_limit    = lookup(each.value.deployment.spec, "revision_history_limit", null)
    dynamic "strategy" {
      for_each = lookup(each.value.deployment.spec, "strategy", null) == null ? {} : { strategy : each.value.deployment.spec.strategy }
      content {
        type = lookup(strategy.value, "type", null)
        dynamic "rolling_update" {
          for_each = lookup(strategy.value, "rolling_update", null) == null ? {} : { rolling_update : strategy.value.rolling_update }
          content {
            max_surge       = strategy.value.rolling_update.max_surge
            max_unavailable = strategy.value.rolling_update.max_unavailable
          }
        }
      }
    }
    dynamic "selector" {
      for_each = lookup(each.value.deployment.spec, "selector", null) == null ? {} : { selector : each.value.deployment.spec.selector }
      content {
        match_labels = lookup(selector.value, "match_labels", null)
      }
    }

    template {
      metadata {
        labels = lookup(each.value.deployment.spec.template.metadata, "labels", {})
      }
      spec {
        active_deadline_seconds         = lookup(each.value.deployment.spec.template.spec, "active_deadline_seconds", null)
        automount_service_account_token = lookup(each.value.deployment.spec.template.spec, "automount_service_account_token", null)
        dns_policy                      = lookup(each.value.deployment.spec.template.spec, "dns_policy", null)
        host_ipc                        = lookup(each.value.deployment.spec.template.spec, "host_ipc", null)
        host_network                    = lookup(each.value.deployment.spec.template.spec, "host_network", null)

        dynamic "dns_config" {
          for_each = lookup(each.value.deployment.spec.template.spec, "dns_config", null) == null ? {} : { dns_config : each.value.deployment.spec.template.spec.dns_config }
          content {
            nameservers = lookup(dns_config.value, "nameservers", null)
            searches    = lookup(dns_config.value, "searches", null)
            dynamic "option" {
              for_each = lookup(dns_config.value, "option", null) == null ? {} : { option : dns_config.value.option }
              content {
                name  = option.value.name
                value = lookup(option.value, "value", null)
              }
            }
          }
        }
        dynamic "host_aliases" {
          for_each = lookup(each.value.deployment.spec.template.spec, "host_aliases", null) == null ? {} : { host_aliases : each.value.deployment.spec.template.spec.host_aliases }
          content {
            hostnames = lookup(host_aliases.value, "hostnames", null)
            ip        = lookup(host_aliases.value, "ip", null)
          }
        }
        dynamic "init_container" {
          for_each = lookup(each.value.deployment.spec.template.spec, "init_container", null) == null ? {} : { init_container : each.value.deployment.spec.template.spec.init_container }
          content {
            name    = lookup(init_container.value, "name", null)
            image   = lookup(init_container.value, "image", null)
            command = lookup(init_container.value, "command", null)
          }
        }
        dynamic "affinity" {
          for_each = lookup(each.value.deployment.spec.template.spec, "affinity", null) == null ? {} : { affinity : each.value.deployment.spec.template.spec.affinity }
          content {
            node_affinity {
              required_during_scheduling_ignored_during_execution {
                node_selector_term {
                  match_expressions {
                    key      = affinity.value.node_affinity.required_during_scheduling_ignored_during_execution.node_selector_term.match_expressions.key
                    operator = affinity.value.node_affinity.required_during_scheduling_ignored_during_execution.node_selector_term.match_expressions.operator
                    values   = lookup(affinity.value.node_affinity.required_during_scheduling_ignored_during_execution.node_selector_term.match_expressions, "values", null)
                  }
                }
              }
            }
          }
        }
        dynamic "container" {
          for_each = lookup(each.value.deployment.spec.template.spec, "container", null) == null ? {} : { container : each.value.deployment.spec.template.spec.container }
          content {
            image             = lookup(container.value, "image", null)
            name              = lookup(container.value, "name", null)
            args              = lookup(container.value, "args", null)
            command           = lookup(container.value, "command", null)
            image_pull_policy = lookup(container.value, "image_pull_policy", null)
            //security_context  = lookup(container.value, "security_context", null)
            //startup_probe = lookup(container.value, "startup_probe", null)
            stdin                    = lookup(container.value, "stdin", null)
            stdin_once               = lookup(container.value, "stdin_once", null)
            termination_message_path = lookup(container.value, "termination_message_path", null)
            tty                      = lookup(container.value, "tty", null)
            working_dir              = lookup(container.value, "working_dir", null)

            dynamic "env" {
              for_each = lookup(container.value, "env", null) == null ? {} : { env : container.value.env }
              content {
                name  = env.value.name
                value = env.value.value
                dynamic "value_from" {
                  for_each = lookup(env.value, "value_from", null) == null ? {} : { value_from : env.value.value_from }
                  content {
                    dynamic "config_map_key_ref" {
                      for_each = lookup(value_from.value, "config_map_key_ref", null) == null ? {} : { config_map_key_ref : value_from.value.config_map_key_ref }
                      content {
                        key      = lookup(config_map_key_ref.value, "key", null)
                        name     = lookup(config_map_key_ref.value, "name", null)
                        optional = lookup(config_map_key_ref.value, "optional", null)
                      }
                    }
                    dynamic "field_ref" {
                      for_each = lookup(value_from.value, "field_ref", null) == null ? {} : { field_ref : value_from.value.field_ref }
                      content {
                        api_version = lookup(field_ref.value, "api_version", null)
                        field_path  = lookup(field_ref.value, "field_path", null)
                      }
                    }
                    dynamic "resource_field_ref" {
                      for_each = lookup(value_from.value, "resource_fielf_ref", null) == null ? {} : { resource_field_ref : value_from.value.resource_field_ref }
                      content {
                        container_name = lookup(resource_field_ref.value, "container_name", null)
                        resource       = lookup(resource_field_ref.value, "resource", null)
                      }
                    }
                    dynamic "secret_key_ref" {
                      for_each = lookup(value_from.value, "secret_key_ref", null) == null ? {} : { secret_key_ref : value_from.value.secret_key_ref }
                      content {
                        key      = lookup(secret_key_ref.value, "key", null)
                        name     = lookup(secret_key_ref.value, "name", null)
                        optional = lookup(secret_key_ref.value, "optional", null)
                      }
                    }
                  }
                }
              }
            }
            dynamic "env_from" {
              for_each = lookup(container.value, "env_from", null) == null ? {} : { env_from : container.value.env_from }
              content {
                dynamic "config_map_ref" {
                  for_each = lookup(env_from.value, "config_map_ref", null) == null ? {} : { config_map_ref : env_from.value.config_map_ref }
                  content {
                    name     = lookup(config_map_ref.value, "name", null)
                    optional = lookup(config_map_ref.value, "optional", null)
                  }
                }
                prefix = lookup(env_from.value, "prefix", null)
                dynamic "secret_ref" {
                  for_each = lookup(env_from.value, "secret_ref", null) == null ? {} : { secret_ref : env_from.value.secret_ref }
                  content {
                    name     = lookup(secret_ref.value, "name", null)
                    optional = lookup(secret_ref.value, "optional", null)
                  }
                }
              }
            }
            dynamic "lifecycle" {
              for_each = lookup(container.value, "lifecycle", null) == null ? {} : { lifecycle : container.value.lifecycle }
              content {
                dynamic "post_start" {
                  for_each = lookup(lifecycle.value, "post_start", null) == null ? {} : { post_start : lifecycle.value.post_start }
                  content {
                    dynamic "exec" {
                      for_each = lookup(post_start.value, "exec", null) == null ? {} : { exec : post_start.value.exec }
                      content {
                        command = exec.value.command
                      }
                    }
                    dynamic "http_get" {
                      for_each = lookup(post_start.value, "http_get", null) == null ? {} : { http_get : post_start.value.http_get }
                      content {
                        host   = lookup(http_get.value, "host", null)
                        path   = lookup(http_get.value, "path", null)
                        scheme = lookup(http_get.value, "scheme", null)
                        port   = http_get.value.port
                        dynamic "http_header" {
                          for_each = lookup(http_get.value, "http_header", null) == null ? {} : { http_header : http_get.value.http_header }
                          content {
                            name  = http_header.value.name
                            value = http_header.value.value
                          }
                        }
                      }
                    }
                    dynamic "tcp_socket" {
                      for_each = lookup(post_start.value, "tcp_socket", null) == null ? {} : { tcp_socket : post_start.value.tcp_socket }
                      content {
                        port = tcp_socket.value.port
                      }
                    }
                  }
                }
                dynamic "pre_stop" {
                  for_each = lookup(lifecycle.value, "pre_stop", null) == null ? {} : { pre_stop : lifecycle.value.pre_stop }
                  content {
                    dynamic "exec" {
                      for_each = lookup(pre_stop.value, "exec", null) == null ? {} : { exec : pre_stop.value.exec }
                      content {
                        command = exec.value.command
                      }
                    }
                    dynamic "http_get" {
                      for_each = lookup(pre_stop.value, "http_get", null) == null ? {} : { http_get : pre_stop.value.http_get }
                      content {
                        host   = lookup(http_get.value, "host", null)
                        path   = lookup(http_get.value, "path", null)
                        scheme = lookup(http_get.value, "scheme", null)
                        port   = lookup(http_get.value, "port", null)
                        dynamic "http_header" {
                          for_each = lookup(http_get.value, "http_header", null) == null ? {} : { http_header : http_get.value.http_header }
                          content {
                            name  = http_header.value.name
                            value = http_header.value.value
                          }
                        }
                      }
                    }
                    dynamic "tcp_socket" {
                      for_each = lookup(pre_stop.value, "tcp_socket", null) == null ? {} : { tcp_socket : pre_stop.value.tcp_socket }
                      content {
                        port = tcp_socket.value.port
                      }
                    }
                  }
                }
              }
            }
            dynamic "port" {
              for_each = lookup(container.value, "port", null) == null ? {} : { port : container.value.port }
              content {
                container_port = port.value.container_port
                host_ip        = lookup(port.value, "host_ip", null)
                host_port      = lookup(port.value, "host_port", null)
                name           = lookup(port.value, "name", null)
                protocol       = lookup(port.value, "protocol", null)
              }
            }
            dynamic "resources" {
              for_each = lookup(container.value, "resources", null) == null ? {} : { resources : container.value.resources }
              content {
                dynamic "limits" {
                  for_each = lookup(resources.value, "limits", null) == null ? {} : { limits : resources.value.limits }
                  content {
                    cpu    = lookup(limits.value, "cpu", null)
                    memory = lookup(limits.value, "memory", null)
                  }
                }
                dynamic "requests" {
                  for_each = lookup(resources.value, "requests", null) == null ? {} : { requests : resources.value.requests }
                  content {
                    cpu    = lookup(requests.value, "cpu", null)
                    memory = lookup(requests.value, "memory", null)
                  }
                }
              }
            }
            dynamic "liveness_probe" {
              for_each = lookup(container.value, "liveness_probe", null) == null ? {} : { liveness_probe : container.value.liveness_probe }
              content {
                initial_delay_seconds = lookup(liveness_probe.value, "initial_delay_seconds", null)
                period_seconds        = lookup(liveness_probe.value, "period_seconds", null)
                timeout_seconds       = lookup(liveness_probe.value, "timeout_seconds", null)
                success_threshold     = lookup(liveness_probe.value, "success_threshold", null)
                failure_threshold     = lookup(liveness_probe.value, "failure_threshold", null)
                dynamic "http_get" {
                  for_each = lookup(liveness_probe.value, "http_get", null) == null ? {} : { http_get : liveness_probe.value.http_get }
                  content {
                    host   = lookup(http_get.value, "host", null)
                    path   = lookup(http_get.value, "path", null)
                    scheme = lookup(http_get.value, "scheme", null)
                    port   = lookup(http_get.value, "port", null)
                    dynamic "http_header" {
                      for_each = lookup(http_get.value, "http_header", null) == null ? {} : { http_header : http_get.value.http_header }
                      content {
                        name  = http_header.value.name
                        value = http_header.value.value
                      }
                    }
                  }
                }
                dynamic "tcp_socket" {
                  for_each = lookup(liveness_probe.value, "tcp_socket", null) == null ? {} : { tcp_socket : liveness_probe.value.tcp_socket }
                  content {
                    port = tcp_socket.value.port
                  }
                }
                dynamic "exec" {
                  for_each = lookup(liveness_probe.value, "exec", null) == null ? {} : { exec : liveness_probe.value.exec }
                  content {
                    command = exec.value.command
                  }
                }
              }
            }
            dynamic "readiness_probe" {
              for_each = lookup(container.value, "readiness_probe", null) == null ? {} : { readiness_probe : container.value.readiness_probe }
              content {
                initial_delay_seconds = lookup(readiness_probe.value, "initial_delay_seconds", null)
                period_seconds        = lookup(readiness_probe.value, "period_seconds", null)
                timeout_seconds       = lookup(readiness_probe.value, "timeout_seconds", null)
                success_threshold     = lookup(readiness_probe.value, "success_threshold", null)
                failure_threshold     = lookup(readiness_probe.value, "failure_threshold", null)
                dynamic "http_get" {
                  for_each = lookup(readiness_probe.value, "http_get", null) == null ? {} : { http_get : readiness_probe.value.http_get }
                  content {
                    host   = lookup(http_get.value, "host", null)
                    path   = lookup(http_get.value, "path", null)
                    scheme = lookup(http_get.value, "scheme", null)
                    port   = lookup(http_get.value, "port", null)
                    dynamic "http_header" {
                      for_each = lookup(http_get.value, "http_header", null) == null ? {} : { http_header : http_get.value.http_header }
                      content {
                        name  = http_header.value.name
                        value = http_header.value.value
                      }
                    }
                  }
                }
                dynamic "tcp_socket" {
                  for_each = lookup(readiness_probe.value, "tcp_socket", null) == null ? {} : { tcp_socket : readiness_probe.value.tcp_socket }
                  content {
                    port = tcp_socket.value.port
                  }
                }
                dynamic "exec" {
                  for_each = lookup(readiness_probe.value, "exec", null) == null ? {} : { exec : readiness_probe.value.exec }
                  content {
                    command = exec.value.command
                  }
                }
              }
            }
            dynamic "volume_mount" {
              for_each = lookup(container.value, "volume_mount", null) == null ? {} : { volume_mount : container.value.volume_mount }
              content {
                mount_path        = lookup(volume_mount.value, "mount_path", null)
                name              = lookup(volume_mount.value, "name", null)
                read_only         = lookup(volume_mount.value, "read_only", null)
                sub_path          = lookup(volume_mount.value, "sub_path", null)
                mount_propagation = lookup(volume_mount.value, "mount_propagation", null)

              }
            }
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "self" {
  for_each = local.k8s_services
  metadata {
    annotations   = lookup(each.value.service.metadata, "annotations", {})
    generate_name = lookup(each.value.service.metadata, "name", null) == null ? lookup(each.value.service.metadata, "generate_name", null) : null
    name          = lookup(each.value.service.metadata, "name", null)
    labels        = lookup(each.value.service.metadata, "labels", {})
    namespace     = lookup(each.value.service.metadata, "namespace", null)
  }
  spec {
    cluster_ip   = lookup(each.value.service.spec, "cluster_ip", null)
    external_ips = lookup(each.value.service.spec, "external_ips", null)
    selector     = lookup(each.value.service.spec, "selector", {})
    port {
      name        = lookup(each.value.service.spec.port, "name", null)
      node_port   = lookup(each.value.service.spec.port, "node_port", null)
      port        = each.value.service.spec.port.port
      protocol    = lookup(each.value.service.spec.port, "protocol", null)
      target_port = lookup(each.value.service.spec.port, "target_port", null)
    }
    type = lookup(each.value.service.spec, "type", null)
  }
}
