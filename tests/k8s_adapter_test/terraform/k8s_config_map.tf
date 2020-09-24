locals {
  k8s_config_map_files = fileset(path.root, "../**/k8s_config_map.y{a,}ml")
  k8s_config_map = {
    for kube_file in local.k8s_config_map_files :
    basename(dirname(kube_file)) => { config_map : yamldecode(file(kube_file)) }
    if ! contains(split("/", kube_file), "terraform")
  }
}

//provider "kubernetes" {
//  load_config_file = true
//}

resource "kubernetes_config_map" "self" {
  for_each = local.k8s_config_map

  metadata {
    annotations   = lookup(each.value.config_map.metadata, "annotations", {})
    generate_name = lookup(each.value.config_map.metadata, "name", null) == null ? lookup(each.value.config_map.metadata, "generate_name", null) : null
    name          = lookup(each.value.config_map.metadata, "name", null)
    labels        = lookup(each.value.config_map.metadata, "labels", {})
    namespace     = lookup(each.value.config_map.metadata, "namespace", null)
  }

  data = merge({
    for key, value in lookup(each.value.config_map, "data", {}) :
    key => value
    },
    {
      for value in lookup(each.value.config_map, "data_file", {}) :
      basename(value) => file(value)
  })
  binary_data = merge({
    for key, value in lookup(each.value.config_map, "binary_data", {}) :
    key => value
    },
    {
      for value in lookup(each.value.config_map, "binary_file", {}) :
      basename(value) => filebase64(value)
  })
}
