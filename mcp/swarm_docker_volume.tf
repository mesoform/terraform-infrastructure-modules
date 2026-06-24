resource "docker_volume" "self" {
  for_each    = local.docker_volume
  name        = lookup(each.value.docker_volume, "name", null)
  driver      = lookup(each.value.docker_volume, "driver", null)
  driver_opts = lookup(each.value.docker_volume, "driver_opts", {})
  dynamic "labels" {
    for_each = lookup(each.value.docker_volume, "labels", null) == null ? {} : { labels : each.value.docker_volume.labels }
    content {
      label = lookup(labels.value, "label", {})
      value = lookup(labels.value, "value", null)
    }
  }
}
