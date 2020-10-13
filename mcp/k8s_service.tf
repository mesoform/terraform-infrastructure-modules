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
    cluster_ip                  = lookup(each.value.service.spec, "cluster_ip", null)
    external_ips                = lookup(each.value.service.spec, "external_ips", null)
    external_name               = lookup(each.value.service.spec, "external_name", null)
    external_traffic_policy     = lookup(each.value.service.spec, "external_traffic_policy", null)
    load_balancer_ip            = lookup(each.value.service.spec, "load_balancer_ip", null)
    load_balancer_source_ranges = lookup(each.value.service.spec, "load_balancer_source_ranges", null)
    publish_not_ready_addresses = lookup(each.value.service.spec, "publish_not_ready_addresses", null)
    selector                    = lookup(each.value.service.spec, "selector", null)
    session_affinity            = lookup(each.value.service.spec, "session_affinity", null)
    type                        = lookup(each.value.service.spec, "type", null)
    health_check_node_port      = lookup(each.value.service.spec, "health_check_node_port", null)

    dynamic "port" {
      for_each = lookup(each.value.service.spec, "port", []) == [] ? [] : [for port in each.value.service.spec.port : {
        name        = lookup(port, "name", null)
        node_port   = lookup(port, "node_port", null)
        port        = lookup(port, "port", null)
        protocol    = lookup(port, "protocol", null)
        target_port = lookup(port, "target_port", null)
      }]
      content {
        name        = lookup(port.value, "name", null)
        node_port   = lookup(port.value, "node_port", null)
        port        = lookup(port.value, "port", null)
        protocol    = lookup(port.value, "protocol", null)
        target_port = lookup(port.value, "target_port", null)
      }
    }
  }
}
