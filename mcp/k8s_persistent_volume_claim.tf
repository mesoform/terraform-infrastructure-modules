resource "kubernetes_persistent_volume_claim" "self" {
  for_each = local.k8s_persistent_volume_claim
  metadata {
    annotations   = lookup(each.value.persistent_volume_claim.metadata, "annotations", null)
    generate_name = lookup(each.value.persistent_volume_claim.metadata, "name", null) == null ? lookup(each.value.persistent_volume_claim.metadata, "generate_name", null) : null
    name          = lookup(each.value.persistent_volume_claim.metadata, "name", null)
    labels        = lookup(each.value.persistent_volume_claim.metadata, "labels", null)
    namespace     = lookup(each.value.persistent_volume_claim.metadata, "namespace", null)
  }
  spec {
    access_modes       = lookup(each.value.persistent_volume_claim.spec, "access_modes", [] )
    volume_name        = lookup(local.k8s_persistent_volume, each.key, null) == null ? lookup(each.value.persistent_volume_claim.spec, "volume_name", null ) : kubernetes_persistent_volume.self[each.key].metadata.0.name
    storage_class_name = lookup(each.value.persistent_volume_claim.spec, "storage_class_name", null )
    //noinspection HILUnresolvedReference
    resources {
      limits   = lookup(each.value.persistent_volume_claim.spec.resources, "limits", {} )
      requests = lookup(each.value.persistent_volume_claim.spec.resources, "requests", {} )
    }
    dynamic "selector" {
      for_each =  lookup(each.value.persistent_volume_claim.spec, "selector",null ) == null ? {} : {selector: each.value.persistent_volume_claim.spec.selector}
      content {
        //noinspection HILUnresolvedReference
        dynamic "match_expressions" {
          for_each = lookup(selector.value, "match_expressions", null) == null ? {}: {
            for match_expression in selector.value.match_expressions:
              match_expression.key => match_expression
          }
          content {
            key = lookup(match_expressions.value, "key", null )
            operator = lookup(match_expressions.value, "operator", null)
            values = lookup(match_expressions.value, "values", null )
          }
        }
        match_labels = lookup(selector.value,"match_labels", null )
      }
    }
  }
}
