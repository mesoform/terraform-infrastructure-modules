resource "kubernetes_horizontal_pod_autoscaler" "self" {
  for_each = local.k8s_pod_autoscaler

  metadata {
    annotations   = lookup(each.value.pod_autoscaler.metadata, "annotations", {})
    generate_name = lookup(each.value.pod_autoscaler.metadata, "name", null) == null ? lookup(each.value.config_map.metadata, "generate_name", null) : null
    name          = lookup(each.value.pod_autoscaler.metadata, "name", null)
    labels        = lookup(each.value.pod_autoscaler.metadata, "labels", {})
    namespace     = lookup(each.value.pod_autoscaler.metadata, "namespace", null)
  }
  spec {
    max_replicas                      = lookup(each.value.pod_autoscaler.spec, "max_replicas", null)
    min_replicas                      = lookup(each.value.pod_autoscaler.spec, "min_replicas", null)
    target_cpu_utilization_percentage = lookup(each.value.pod_autoscaler.spec, "target_cpu_utilization_percentage", null)
    dynamic "scale_target_ref" {
      for_each = lookup(each.value.pod_autoscaler.spec, "scale_target_ref", null) == null ? {} : { scale_target_ref : each.value.pod_autoscaler.spec.scale_target_ref }
      content {
        api_version = lookup(scale_target_ref.value, "api_version", null)
        kind        = lookup(scale_target_ref.value, "kind", null)
        name        = lookup(scale_target_ref.value, "name", null)
      }
    }
    dynamic "metric" {
      for_each = lookup(each.value.pod_autoscaler.spec, "metric", null) == null ? {} : { metric : each.value.pod_autoscaler.spec.metric }
      content {
        type = lookup(metric.value, "type", null)

        dynamic "pods" {
          for_each = lookup(metric.value, "pods", null) == null ? {} : { pods : metric.value.pods }
          content {
            dynamic "metric" {
              for_each = lookup(pods.value, "metric", null) == null ? {} : { metric : pods.value.metric }
              content {
                name = lookup(metric.value, "name", null)
                dynamic "selector" {
                  for_each = lookup(metric.value, "selector", null) == null ? {} : { selector : metric.value.selector }
                  content {
                    match_labels = lookup(selector.value, "match_labels", null)
                  }
                }
              }
            }
            dynamic "target" {
              for_each = lookup(pods.value, "target", null) == null ? {} : { object : pods.value.target }
              content {
                type                = lookup(target.value, "type", null)
                average_value       = lookup(target.value, "average_value", null)
                average_utilization = lookup(target.value, "average_utilization", null)
                value               = lookup(target.value, "value", null)
              }
            }
          }
        }
        dynamic "external" {
          for_each = lookup(metric.value, "external", null) == null ? {} : { external : metric.value.external }
          content {
            dynamic "metric" {
              for_each = lookup(external.value, "metric", null) == null ? {} : { metric : external.value.metric }
              content {
                name = lookup(metric.value, "name", null)
                dynamic "selector" {
                  for_each = lookup(metric.value, "selector", null) == null ? {} : { selector : metric.value.selector }
                  content {
                    match_labels = lookup(selector.value, "match_labels", null)
                  }
                }
              }
            }
            dynamic "target" {
              for_each = lookup(external.value, "target", null) == null ? {} : { external : external.value.target }
              content {
                type                = lookup(target.value, "type", null)
                average_value       = lookup(target.value, "average_value", null)
                average_utilization = lookup(target.value, "average_utilization", null)
                value               = lookup(target.value, "value", null)
              }
            }
          }
        }
        dynamic "object" {
          for_each = lookup(metric.value, "object", null) == null ? {} : { object : metric.value.object }
          content {
            dynamic "described_object" {
              for_each = lookup(object.value, "described_object", null) == null ? {} : { described_object : object.value.described_object }
              content {
                api_version = lookup(described_object.value, "api_version", null)
                kind        = lookup(described_object.value, "kind", null)
                name        = lookup(described_object.value, "name", null)
              }
            }
            dynamic "metric" {
              for_each = lookup(object.value, "metric", null) == null ? {} : { metric : object.value.metric }
              content {
                name = lookup(metric.value, "name", null)
                dynamic "selector" {
                  for_each = lookup(metric.value, "selector", null) == null ? {} : { selector : metric.value.selector }
                  content {
                    match_labels = lookup(selector.value, "match_labels", null)
                  }
                }
              }
            }
            dynamic "target" {
              for_each = lookup(object.value, "target", null) == null ? {} : { object : object.value.target }
              content {
                type                = lookup(target.value, "type", null)
                average_value       = lookup(target.value, "average_value", null)
                average_utilization = lookup(target.value, "average_utilization", null)
                value               = lookup(target.value, "value", null)
              }
            }
          }
        }
        dynamic "resource" {
          for_each = lookup(metric.value, "resource", null) == null ? {} : { resource : metric.value.resource }
          content {
            name = lookup(resource.value, "name", null)
            dynamic "target" {
              for_each = lookup(resource.value, "target", null) == null ? {} : { target : resource.value.target }
              content {
                type                = lookup(target.value, "type", null)
                average_value       = lookup(target.value, "average_value", null)
                average_utilization = lookup(target.value, "average_utilization", null)
                value               = lookup(target.value, "value", null)
              }
            }
          }
        }
      }
    }
  }
}
