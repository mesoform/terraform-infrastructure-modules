resource "docker_secret" "self" {
  for_each = local.docker_secret
  name     = lookup(each.value.docker_secret, "name", null)
  data     = base64encode(lookup(each.value.docker_secret, "data", null))
  dynamic "labels" {
    for_each = lookup(each.value.docker_secret, "labels", null) == null ? {} : { labels : each.value.docker_secret.labels }
    content {
      label = lookup(labels.value, "label", {})
      value = lookup(labels.value, "value", null)
    }
  }
}
