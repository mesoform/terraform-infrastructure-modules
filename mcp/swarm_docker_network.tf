resource "docker_network" "self" {
  for_each        = local.docker_network
  name            = lookup(each.value.docker_network, "name", null)
  attachable      = lookup(each.value.docker_network, "attachable", null)
  check_duplicate = lookup(each.value.docker_network, "check_duplicate", null)
  driver          = lookup(each.value.docker_network, "driver", null)
  ingress         = lookup(each.value.docker_network, "ingress", null)
  internal        = lookup(each.value.docker_network, "internal", null)
  ipam_driver     = lookup(each.value.docker_network, "ipam_driver", null)
  ipv6            = lookup(each.value.docker_network, "ipv6", null)
  options         = lookup(each.value.docker_network, "options", {})
  dynamic "ipam_config" {
    for_each = lookup(each.value.docker_network, "ipam_config", null) == null ? {} : { ipam_config : each.value.docker_network.ipam_config }
    content {
      aux_address = lookup(ipam_config.value, "aux_address", {})
      gateway     = lookup(ipam_config.value, "gateway", null)
      ip_range    = lookup(ipam_config.value, "ip_range", null)
      subnet      = lookup(ipam_config.value, "subnet", null)
    }
  }
  dynamic "labels" {
    for_each = lookup(each.value.docker_network, "labels", null) == null ? {} : { labels : each.value.docker_network.labels }
    content {
      label = lookup(labels.value, "label", {})
      value = lookup(labels.value, "value", null)
    }
  }
}
