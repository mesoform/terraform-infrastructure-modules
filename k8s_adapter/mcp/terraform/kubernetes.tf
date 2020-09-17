locals {
  k8s_services_files = fileset(path.root, "../**/k8s_service.y{a,}ml")
  //k8s_services = {
  //  for kube_file in local.k8s_services_files :
  //  basename(dirname(kube_file)) => { service : yamldecode(file(kube_file)) }
  //  if ! contains(split("/", kube_file), "terraform")
  //}
  k8s_services = {
    for kube_file in local.k8s_services_files :
    index(tolist(local.k8s_services_files), kube_file) => { service : yamldecode(file(kube_file)) }
    if ! contains(split("/", kube_file), "terraform")
  }


  k8s_deployments_files = fileset(path.root, "../**/k8s_deployment.y{a,}ml")
  //k8s_deployments = {
  //  for kube_file in local.k8s_deployments_files :
  //  basename(dirname(kube_file)) => { deployment : yamldecode(file(kube_file)) }
  //  if ! contains(split("/", kube_file), "terraform")
  //}
  k8s_deployments = {
    for kube_file in local.k8s_deployments_files :
    index(tolist(local.k8s_deployments_files), kube_file) => { deployment : yamldecode(file(kube_file)) }
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
            image = lookup(container.value, "image", null)
            name  = lookup(container.value, "name", null)
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
                    cpu    = limits.value.cpu
                    memory = limits.value.memory
                  }
                }
                dynamic "requests" {
                  for_each = lookup(resources.value, "requests", null) == null ? {} : { requests : resources.value.requests }
                  content {
                    cpu    = requests.value.cpu
                    memory = requests.value.memory
                  }
                }
              }
            }
            dynamic "liveness_probe" {
              for_each = lookup(container.value, "liveness_probe", null) == null ? {} : { liveness_probe : container.value.liveness_probe }
              content {
                initial_delay_seconds = lookup(liveness_probe.value, "initial_delay_seconds", null)
                period_seconds        = lookup(liveness_probe.value, "period_seconds", null)
                dynamic "http_get" {
                  for_each = lookup(liveness_probe.value, "http_get", null) == null ? {} : { http_get : liveness_probe.value.http_get }
                  content {
                    path = http_get.value.path
                    port = http_get.value.port
                    dynamic "http_header" {
                      for_each = lookup(http_get.value, "http_header", null) == null ? {} : { http_header : http_get.value.http.header }
                      content {
                        name  = http_header.value.name
                        value = http_header.value.value
                      }
                    }
                  }
                }
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
