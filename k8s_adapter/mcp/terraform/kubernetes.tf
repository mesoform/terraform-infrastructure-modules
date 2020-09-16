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
  count            = length(local.k8s_deployments)
  wait_for_rollout = lookup(local.k8s_deployments[count.index].deployment, "wait_for_rollout", true)
  metadata {
    annotations   = lookup(local.k8s_deployments[count.index].deployment.metadata, "annotations", {})
    generate_name = lookup(local.k8s_deployments[count.index].deployment.metadata, "name", null) == null ? lookup(local.k8s_deployments[count.index].deployment.metadata, "generate_name", {}) : null
    name          = lookup(local.k8s_deployments[count.index].deployment.metadata, "name", null)
    labels        = lookup(local.k8s_deployments[count.index].deployment.metadata, "labels", {})
    namespace     = lookup(local.k8s_deployments[count.index].deployment.metadata, "namespace", null)
  }
  spec {
    min_ready_seconds         = lookup(local.k8s_deployments[count.index].deployment.spec, "min_ready_seconds", null)
    paused                    = lookup(local.k8s_deployments[count.index].deployment.spec, "paused", null)
    progress_deadline_seconds = lookup(local.k8s_deployments[count.index].deployment.spec, "progress_deadline_seconds", null)
    replicas                  = lookup(local.k8s_deployments[count.index].deployment.spec, "replicas", null)
    revision_history_limit    = lookup(local.k8s_deployments[count.index].deployment.spec, "revision_history_limit", null)
    dynamic "strategy" {
      for_each = lookup(local.k8s_deployments[count.index].deployment.spec, "strategy", null) == null ? [] : [count.index]
      content {
        type = lookup(local.k8s_deployments[count.index].deployment.spec.strategy, "type", null)
        dynamic "rolling_update" {
          for_each = lookup(local.k8s_deployments[count.index].deployment.spec.strategy, "rolling_update", null) == null ? [] : [count.index]
          content {
            max_surge       = local.k8s_deployments[count.index].deployment.spec.strategy.rolling_update.max_surge
            max_unavailable = local.k8s_deployments[count.index].deployment.spec.strategy.rolling_update.max_unavailable
          }
        }
      }
    }
    dynamic "selector" {
      for_each = lookup(local.k8s_deployments[count.index].deployment.spec, "selector", null) == null ? [] : [count.index]
      content {
        match_labels = lookup(local.k8s_deployments[count.index].deployment.spec.selector, "match_labels", null)
      }
    }

    template {
      metadata {
        labels = lookup(local.k8s_deployments[count.index].deployment.spec.template.metadata, "labels", {})
      }
      spec {
        dynamic "affinity" {
          for_each = lookup(local.k8s_deployments[count.index].deployment.spec.template.spec, "affinity", null) == null ? [] : [count.index]
          content {
            node_affinity {
              required_during_scheduling_ignored_during_execution {
                node_selector_term {
                  match_expressions {
                    key      = local.k8s_deployments[count.index].deployment.spec.template.spec.affinity.node_affinity.required_during_scheduling_ignored_during_execution.node_selector_term.match_expressions.key
                    operator = local.k8s_deployments[count.index].deployment.spec.template.spec.affinity.node_affinity.required_during_scheduling_ignored_during_execution.node_selector_term.match_expressions.operator
                    values   = lookup(local.k8s_deployments[count.index].deployment.spec.template.spec.affinity.node_affinity.required_during_scheduling_ignored_during_execution.node_selector_term.match_expressions, "values", null)
                  }
                }
              }
            }
          }
        }
        dynamic "container" {
          for_each = lookup(local.k8s_deployments[count.index].deployment.spec.template.spec, "container", null) == null ? [] : [count.index]
          content {
            image = lookup(local.k8s_deployments[count.index].deployment.spec.template.spec.container, "image", null)
            name  = lookup(local.k8s_deployments[count.index].deployment.spec.template.spec.container, "name", null)
            dynamic "port" {
              for_each = lookup(local.k8s_deployments[count.index].deployment.spec.template.spec.container, "port", null) == null ? [] : [count.index]
              content {
                container_port = local.k8s_deployments[count.index].deployment.spec.template.spec.container.port.container_port
                host_ip        = lookup(local.k8s_deployments[count.index].deployment.spec.template.spec.container.port, "host_ip", null)
                host_port      = lookup(local.k8s_deployments[count.index].deployment.spec.template.spec.container.port, "host_port", null)
                name           = lookup(local.k8s_deployments[count.index].deployment.spec.template.spec.container.port, "name", null)
                protocol       = lookup(local.k8s_deployments[count.index].deployment.spec.template.spec.container.port, "protocol", null)
              }
            }
            dynamic "resources" {
              for_each = lookup(local.k8s_deployments[count.index].deployment.spec.template.spec.container, "resources", null) == null ? [] : [count.index]
              content {
                dynamic "limits" {
                  for_each = lookup(local.k8s_deployments[count.index].deployment.spec.template.spec.container.resources, "limits", null) == null ? [] : [count.index]
                  content {
                    cpu    = local.k8s_deployments[count.index].deployment.spec.template.spec.container.resources.limits.cpu
                    memory = local.k8s_deployments[count.index].deployment.spec.template.spec.container.resources.limits.memory
                  }
                }
                dynamic "requests" {
                  for_each = lookup(local.k8s_deployments[count.index].deployment.spec.template.spec.container.resources, "requests", null) == null ? [] : [count.index]
                  content {
                    cpu    = local.k8s_deployments[count.index].deployment.spec.template.spec.container.resources.requests.cpu
                    memory = local.k8s_deployments[count.index].deployment.spec.template.spec.container.resources.requests.memory
                  }
                }
              }
            }
            dynamic "liveness_probe" {
              for_each = lookup(local.k8s_deployments[count.index].deployment.spec.template.spec.container, "liveness_probe", null) == null ? [] : [count.index]
              content {
                dynamic "http_get" {
                  for_each = lookup(local.k8s_deployments[count.index].deployment.spec.template.spec.container.liveness_probe, "http_get", null) == null ? [] : [count.index]
                  content {
                    path = local.k8s_deployments[count.index].deployment.spec.template.spec.container.liveness_probe.http_get.path
                    port = local.k8s_deployments[count.index].deployment.spec.template.spec.container.liveness_probe.http_get.port
                    dynamic "http_header" {
                      for_each = lookup(local.k8s_deployments[count.index].deployment.spec.template.spec.container.liveness_probe.http_get, "http_header", null) == null ? [] : [count.index]
                      content {
                        name  = local.k8s_deployments[count.index].deployment.spec.template.spec.container.liveness_probe.http_get.http_header.name
                        value = local.k8s_deployments[count.index].deployment.spec.template.spec.container.liveness_probe.http_get.http_header.value
                      }
                    }
                  }
                }
                initial_delay_seconds = lookup(local.k8s_deployments[count.index].deployment.spec.template.spec.container.liveness_probe, "initial_delay_seconds", null)
                period_seconds        = lookup(local.k8s_deployments[count.index].deployment.spec.template.spec.container.liveness_probe, "period_seconds", null)
              }
            }
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "self" {
  count = length(local.k8s_services)
  metadata {
    annotations   = lookup(local.k8s_services[count.index].service.metadata, "annotations", {})
    generate_name = lookup(local.k8s_services[count.index].service.metadata, "name", null) == null ? lookup(local.k8s_deployments[count.index].deployment.metadata, "generate_name", {}) : null
    name          = lookup(local.k8s_services[count.index].service.metadata, "name", null)
    labels        = lookup(local.k8s_services[count.index].service.metadata, "labels", {})
    namespace     = lookup(local.k8s_services[count.index].service.metadata, "namespace", null)
  }

  spec {
    selector = lookup(local.k8s_services[count.index].service.spec, "selector", {})
    port {
      name        = lookup(local.k8s_services[count.index].service.spec.port, "name", null)
      node_port   = lookup(local.k8s_services[count.index].service.spec.port, "node_port", null)
      port        = local.k8s_services[count.index].service.spec.port.port
      protocol    = lookup(local.k8s_services[count.index].service.spec.port, "protocol", null)
      target_port = lookup(local.k8s_services[count.index].service.spec.port, "target_port", null)
    }
    type = lookup(local.k8s_services[count.index].service.spec, "type", null)
  }
}
