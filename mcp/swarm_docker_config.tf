resource "docker_config" "self" {
  for_each = local.docker_config
  name = lookup(each.value.docker_config, "name", null)
  data = base64encode(lookup(each.value.docker_config, "data", null))
}
