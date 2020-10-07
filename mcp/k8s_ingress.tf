//noinspection HILUnresolvedReference
resource "kubernetes_ingress" "self" {
  for_each = local.k8s_ingress
  wait_for_load_balancer = lookup(each.value.ingress, "wait_for_load_balancer", false)
  //noinspection HILUnresolvedReference
  metadata {
    name          = lookup(each.value.ingress.metadata, "name", null)
    generate_name = lookup(each.value.ingress.metadata, "name", null) == null ? lookup(each.value.service.metadata, "generate_name", null) : null
    labels        = lookup(each.value.ingress.metadata, "labels", {})
    namespace = lookup(each.value.ingress.metadata, "namespace", null)
    annotations   = lookup(each.value.ingress.metadata, "annotations", {})
  }
  spec {
    //noinspection HILUnresolvedReference
    dynamic "backend" {
      for_each = lookup(each.value.ingress.spec, "backend", null) != null ? {backend : each.value.ingress.spec.backend} : {}
      content{
        service_name = lookup(backend.value, "service_name", null)
        service_port = lookup(backend.value, "service_port", null)
      }
    }

    //noinspection HILUnresolvedReference
    dynamic "rule" {
      for_each = lookup(each.value.ingress.spec, "rule", null) != null ? {rule : each.value.ingress.spec.rule} : {}
      content {
        # host = lookup(each.value.ingress.spec.rule, "host", {})
        host = lookup(rule.value, "host", {})
        http{
          //noinspection HILUnresolvedReference
          dynamic "path" {
            for_each = lookup(rule.value.http, "paths")
            content {
              path = lookup(path.value, "path", "")
              //noinspection HILUnresolvedReference
              backend{
                service_name = lookup(path.value.backend, "service_name", null)
                service_port = lookup(path.value.backend, "service_port", null)
              }
            }
          }
        }
      }
    }


    //noinspection HILUnresolvedReference
    dynamic tls{
      for_each = lookup(each.value.ingress.spec, "tls", null) != null ? {tls : each.value.ingress.spec.tls} : {}
      content {
        hosts = lookup(tls.value, "hosts", [])
        secret_name = lookup(tls.value, "secret_name", null)
      }
    }
  }
}