
resource "kubernetes_config_map" "self" {
  for_each = local.k8s_config_map

  metadata {
    annotations   = lookup(each.value.config_map.metadata, "annotations", {})
    generate_name = lookup(each.value.config_map.metadata, "name", null) == null ? lookup(each.value.config_map.metadata, "generate_name", null) : null
    name          = lookup(each.value.config_map.metadata, "name", null)
    labels        = lookup(each.value.config_map.metadata, "labels", {})
    namespace     = lookup(each.value.config_map.metadata, "namespace", null)
  }

  data        = lookup(local.k8s_config_map_data, each.key, {})
  binary_data = lookup(local.k8s_config_map_binary_data, each.key, {})
}
