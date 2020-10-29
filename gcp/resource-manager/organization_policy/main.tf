resource google_organization_policy self {
  for_each = local.organization_level_policies

  org_id     = local.organization_id
  constraint = lookup(each.value, "constraint")

  dynamic list_policy {
    for_each = lookup(each.value, "list_policy", null) == null ? {} : {list_policy: lookup(each.value, "list_policy")}
    content {
      inherit_from_parent = false
      dynamic deny {
        for_each = length(lookup(list_policy.value, "deny")) == 0 ? {} : {deny: lookup(list_policy.value, "deny")}
        content {
          values = deny.value == [] ? null : deny.value.0 == "all" ? null : deny.value
          all = deny.value == [] ? null : deny.value.0 == "all" ? true : null
        }
      }
      dynamic allow {
        for_each = length(lookup(list_policy.value, "allow")) == 0 ? {} : {allow: lookup(list_policy.value, "allow")}
        content {
          values = allow.value == [] ? null : allow.value.0 == "all" ? null : allow.value
          all = allow.value == [] ? null : allow.value.0 == "all" ? true : null
        }
      }
    }
  }
  dynamic boolean_policy {
    for_each = lookup(each.value, "boolean_policy", null) == null ? {} : {boolean_policy: lookup(each.value, "boolean_policy")}
    content {
      enforced = lookup(boolean_policy.value, "enforced", false)
    }
  }
  dynamic restore_policy {
    for_each = lookup(each.value, "restore_policy", null) == null ? {} : {restore_policy: lookup(each.value, "restore_policy")}
    content {
      default = lookup(restore_policy.value, "default", false)
    }
  }
}

resource google_folder_organization_policy self {
  for_each = local.folder_level_policies

  folder     = lookup(each.value, "folder_number")
  constraint = lookup(each.value, "constraint")

  dynamic list_policy {
    for_each = lookup(each.value, "list_policy", null) == null ? {} : {list_policy: lookup(each.value, "list_policy")}
    content {
      inherit_from_parent = lookup(list_policy.value, "inherit_from_parent")
      dynamic deny {
        for_each = length(lookup(list_policy.value, "deny")) == 0 ? {} : {deny: lookup(list_policy.value, "deny")}
        content {
          values = deny.value == [] ? null : deny.value.0 == "all" ? null : deny.value
          all = deny.value == [] ? null : deny.value.0 == "all" ? true : null
        }
      }
      dynamic allow {
        for_each = length(lookup(list_policy.value, "allow")) == 0 ? {} : {allow: lookup(list_policy.value, "allow")}
        content {
          values = allow.value == [] ? null : allow.value.0 == "all" ? null : allow.value
          all = allow.value == [] ? null : allow.value.0 == "all" ? true : null
        }
      }
    }
  }
  dynamic boolean_policy {
    for_each = lookup(each.value, "boolean_policy", null) == null ? {} : {boolean_policy: lookup(each.value, "boolean_policy")}
    content {
      enforced = lookup(boolean_policy.value, "enforced", null)
    }
  }
  dynamic restore_policy {
    for_each = lookup(each.value, "restore_policy", null) == null ? {} : {restore_policy: lookup(each.value, "restore_policy")}
    content {
      default = lookup(restore_policy.value, "default", false)
    }
  }
}

resource google_project_organization_policy self {
  for_each = local.project_level_policies
  constraint = lookup(each.value, "constraint")
  project = lookup(each.value, "project_id")

  dynamic list_policy {
    for_each = lookup(each.value, "list_policy", null) == null ? {} : {list_policy: lookup(each.value, "list_policy")}
    content {
      inherit_from_parent = lookup(list_policy.value, "inherit_from_parent")
      dynamic deny {
        for_each = length(lookup(list_policy.value, "deny")) == 0 ? {} : {deny: lookup(list_policy.value, "deny")}
        content {
          values = deny.value == [] ? null : deny.value.0 == "all" ? null : deny.value
          all = deny.value == [] ? null : deny.value.0 == "all" ? true : null
        }
      }
      dynamic allow {
        for_each = length(lookup(list_policy.value, "allow")) == 0 ? {} : {allow: lookup(list_policy.value, "allow")}
        content {
          values = allow.value == [] ? null : allow.value.0 == "all" ? null : allow.value
          all = allow.value == [] ? null : allow.value.0 == "all" ? true : null
        }
      }
    }
  }
  dynamic boolean_policy {
    for_each = lookup(each.value, "boolean_policy", null) == null ? {} : {boolean_policy: lookup(each.value, "boolean_policy")}
    content {
      enforced = lookup(boolean_policy.value, "enforced", null)
    }
  }
  dynamic restore_policy {
    for_each = lookup(each.value, "restore_policy", null) == null ? {} : {restore_policy: lookup(each.value, "restore_policy")}
    content {
      default = lookup(restore_policy.value, "default", false)
    }
  }
}
