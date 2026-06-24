resource "docker_plugin" "self" {
  for_each              = local.docker_plugin
  name                  = lookup(each.value.docker_plugin, "name", null)
  alias                 = lookup(each.value.docker_plugin, "alias", null)
  enable_timeout        = lookup(each.value.docker_plugin, "enable_timeout", null)
  enabled               = lookup(each.value.docker_plugin, "enabled", null)
  env                   = lookup(each.value.docker_plugin, "env", null)
  force_destroy         = lookup(each.value.docker_plugin, "force_destroy", null)
  force_disable         = lookup(each.value.docker_plugin, "force_disable", null)
  grant_all_permissions = lookup(each.value.docker_plugin, "grant_all_permissions", null)
  dynamic "grant_permissions" {
    for_each = lookup(each.value.docker_plugin, "grant_permissions", null) == null ? {} : { grant_permissions : each.value.docker_plugin.grant_permissions }
    content {
      name  = lookup(grant_permissions.value, "name", {})
      value = lookup(grant_permissions.value, "value", null)
    }
  }
}
