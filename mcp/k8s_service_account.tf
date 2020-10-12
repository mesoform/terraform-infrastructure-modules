resource "kubernetes_service_account" "self" {
  for_each = local.k8s_service_account

  metadata {
    annotations   = lookup(each.value.service_account.metadata, "annotations", {})
    generate_name = lookup(each.value.service_account.metadata, "name", null) == null ? lookup(each.value.config_map.metadata, "generate_name", null) : null
    name          = lookup(each.value.service_account.metadata, "name", null)
    labels        = lookup(each.value.service_account.metadata, "labels", {})
    namespace     = lookup(each.value.service_account.metadata, "namespace", null)
  }
  dynamic image_pull_secret {
    for_each = lookup(each.value.service_account, "image_pull_secret", []) == [] ? [] : [for image_pull_secret in lookup(each.value.service_account, "image_pull_secret", null) : {
      name = lookup(image_pull_secret, "name", null)
    }]
    content {
      name = lookup(image_pull_secret.value, "name", {})
    }
  }
  dynamic secret {
    for_each = lookup(each.value.service_account, "secret", []) == [] ? [] : [for secret in lookup(each.value.service_account, "secret", null) : {
      name = lookup(secret, "name", null)
    }]
    content {
      name = lookup(secret.value, "name", null)
    }
  }
  automount_service_account_token = lookup(each.value.service_account, "automount_service_account_tokens", false)
}
