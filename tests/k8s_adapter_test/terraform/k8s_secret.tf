resource "kubernetes_secret" "self" {
  for_each = local.k8s_secret

  metadata {
    annotations   = lookup(each.value.secret.metadata, "annotations", {})
    generate_name = lookup(each.value.secret.metadata, "name", null) == null ? lookup(each.value.config_map.metadata, "generate_name", null) : null
    name          = lookup(each.value.secret.metadata, "name", null)
    labels        = lookup(each.value.secret.metadata, "labels", {})
    namespace     = lookup(each.value.secret.metadata, "namespace", null)
  }

  data = merge({
    for key, value in lookup(each.value.secret, "data", {}) :
    key => value
    },
    {
      for value in lookup(each.value.secret, "data_file", {}) :
      basename(value) => file(value)
  })
  type = lookup(each.value.secret, "type", null)

}
