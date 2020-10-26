/******************************************
  Locals policyuration for module logic
 *****************************************/
locals {
  organization_id = var.organization_id
  organization_level_list_policies = {
    for policy in var.organization_policies:
      "${lookup(policy, "constraint")}-${var.organization_id}" => {
        constraint: lookup(policy, "constraint")
        list_policy: {
          deny: compact(split(" ", lookup(policy, "deny", "")))
          allow: compact(split(" ", lookup(policy, "allow", "")))
        }
      } if lookup(policy, "deny", false) != false || lookup(policy, "allow", false) != false
  }
  organization_level_boolean_policies = {
    for policy in var.organization_policies:
      "${lookup(policy, "constraint")}-${var.organization_id}" => {
        constraint: lookup(policy, "constraint")
        boolean_policy: {
          enforced: lookup(policy, "enforced")
        }
      } if lower(lookup(policy, "enforced", "false")) == "true"
  }
  organization_level_restore_policies = {
    for policy in var.organization_policies:
      "${lookup(policy, "constraint")}-${var.organization_id}" => {
        constraint: lookup(policy, "constraint")
        restore_policy: {
          default: lookup(policy, "restore_default")
        }
      } if lower(lookup(policy, "restore_default", "false")) == "true"
  }
  organization_level_policies = merge(
    local.organization_level_list_policies,
    local.organization_level_boolean_policies,
    local.organization_level_restore_policies
  )

  folder_level_list_policies = {
    for policy in var.folder_policies:
      "${lookup(policy, "constraint")}-${lookup(policy, "folder_number")}" => {
        constraint: lookup(policy, "constraint")
        folder_number: lookup(policy, "folder_number")
        list_policy: {
          inherit_from_parent: lookup(policy, "inherit_from_parent", true)
          deny: compact(split(" ", lookup(policy, "deny", "")))
          allow: compact(split(" ", lookup(policy, "allow", "")))
        }
      } if lookup(policy, "deny", false) != false || lookup(policy, "allow", false) != false
  }
  folder_level_boolean_policies = {
    for policy in var.folder_policies:
      "${lookup(policy, "constraint")}-${lookup(policy, "folder_number")}" => {
        constraint: lookup(policy, "constraint")
        folder_number: lookup(policy, "folder_number")
        boolean_policy: {
          enforced: lookup(policy, "enforced")
        }
      } if lower(lookup(policy, "enforced", "false")) == "true"
  }
  folder_level_restore_policies = {
    for policy in var.folder_policies:
      "${lookup(policy, "constraint")}-${lookup(policy, "folder_number")}" => {
        constraint: lookup(policy, "constraint")
        folder_number: lookup(policy, "folder_number")
        restore_policy: {
          default: lookup(policy, "restore_default")
        }
      } if lower(lookup(policy, "restore_default", "false")) == "true"
  }
  folder_level_policies = merge(
    local.folder_level_list_policies,
    local.folder_level_boolean_policies,
    local.folder_level_restore_policies
  )

  project_level_list_policies = {
    for policy in var.project_policies:
      "${lookup(policy, "constraint")}-${lookup(policy, "project_id")}" => {
        constraint: lookup(policy, "constraint")
        project_id: lookup(policy, "project_id")
        list_policy: {
          inherit_from_parent: lookup(policy, "inherit_from_parent", true)
          deny: compact(split(" ", lookup(policy, "deny", "")))
          allow: compact(split(" ", lookup(policy, "allow", "")))
        }
      } if lookup(policy, "deny", false) != false || lookup(policy, "allow", false) != false
  }
  project_level_boolean_policies = {
    for policy in var.project_policies:
      "${lookup(policy, "constraint")}-${lookup(policy, "project_id")}" => {
        constraint: lookup(policy, "constraint")
        project_id: lookup(policy, "project_id")
        boolean_policy: {
          enforced: lookup(policy, "enforced")
        }
      } if lower(lookup(policy, "enforced", "false")) == "true"
  }
  project_level_restore_policies = {
    for policy in var.project_policies:
      "${lookup(policy, "constraint")}-${lookup(policy, "project_id")}" => {
        constraint: lookup(policy, "constraint")
        project_id: lookup(policy, "project_id")
        restore_policy: {
          default: lookup(policy, "restore_default")
        }
      } if lower(lookup(policy, "restore_default", "false")) == "true"
  }
  project_level_policies = merge(
    local.project_level_list_policies,
    local.project_level_boolean_policies,
    local.project_level_restore_policies
  )
}