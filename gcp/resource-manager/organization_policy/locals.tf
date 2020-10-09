/******************************************
  Locals configuration for module logic
 *****************************************/
locals {
  organization_id = var.organization_id
//  organization   = var.policy_for == "organization"
//  folder         = var.policy_for == "folder"
//  project        = var.policy_for == "project"
//  boolean_policy = var.policy_type == "boolean"
//  list_policy    = var.policy_type == "list" && ! local.invalid_config
//
//  // If allow/deny list empty and enforce is not set, enforce is set to true
//  enforce               = var.allow_list_length > 0 || var.deny_list_length > 0 ? null : var.enforce != false
//  invalid_config_case_1 = var.deny_list_length > 0 && var.allow_list_length > 0
//
//  // We use var.enforce here because allow/deny lists can not be used together with enforce flag
//  invalid_config_case_2 = var.allow_list_length + var.deny_list_length > 0 && var.enforce != null
//  invalid_config        = var.policy_type == "list" && local.invalid_config_case_1 || local.invalid_config_case_2
  organization_level_list_policies = {
    for policy, config in var.organization_policies:
      policy => {
        list_policy: {
          deny: compact(split(" ", lookup(config, "deny", "")))
          allow: compact(split(" ", lookup(config, "allow", "")))
        }
      } if lookup(config, "deny", false) != false || lookup(config, "allow", false) != false
  }
  organization_level_boolean_policies = {
    for policy, config in var.organization_policies:
      policy => {
        boolean_policy: {
          enforced: lookup(config, "enforced")
        }
      } if lower(lookup(config, "enforced", "false")) == "true"
  }
  organization_level_restore_policies = {
    for policy, config in var.organization_policies:
      policy => {
        restore_policy: {
          default: lookup(config, "restore_default")
        }
      } if lower(lookup(config, "restore_default", "false")) == "true"
  }
  organization_level_policies = merge(
    local.organization_level_list_policies,
    local.organization_level_boolean_policies,
    local.organization_level_restore_policies
  )

  folder_level_list_policies = {
    for policy, config in var.folder_policies:
      policy => {
        folder_number: lookup(config, "folder_number")
        list_policy: {
          inherit_from_parent: lookup(config, "inherit_from_parent", true)
          deny: compact(split(" ", lookup(config, "deny", "")))
          allow: compact(split(" ", lookup(config, "allow", "")))
        }
      } if lookup(config, "deny", false) != false || lookup(config, "allow", false) != false
  }
  folder_level_boolean_policies = {
    for policy, config in var.folder_policies:
      policy => {
        boolean_policy: {
          enforced: lookup(config, "enforced")
        }
      } if lower(lookup(config, "enforced", "false")) == "true"
  }
  folder_level_restore_policies = {
    for policy, config in var.folder_policies:
      policy => {
        restore_policy: {
          default: lookup(config, "restore_default")
        }
      } if lower(lookup(config, "restore_default", "false")) == "true"
  }
  folder_level_policies = merge(
    local.folder_level_list_policies,
    local.folder_level_boolean_policies,
    local.folder_level_restore_policies
  )

  project_level_list_policies = {
    for policy, config in var.project_policies:
      policy => {
        project_id: lookup(config, "project_id")
        list_policy: {
          inherit_from_parent: lookup(config, "inherit_from_parent", true)
          deny: compact(split(" ", lookup(config, "deny", "")))
          allow: compact(split(" ", lookup(config, "allow", "")))
        }
      } if lookup(config, "deny", false) != false || lookup(config, "allow", false) != false
  }
  project_level_boolean_policies = {
    for policy, config in var.project_policies:
      policy => {
        boolean_policy: {
          enforced: lookup(config, "enforced")
        }
      } if lower(lookup(config, "enforced", "false")) == "true"
  }
  project_level_restore_policies = {
    for policy, config in var.project_policies:
      policy => {
        project_id: lookup(config, "project_id")
        restore_policy: {
          default: lookup(config, "restore_default")
        }
      } if lower(lookup(config, "restore_default", "false")) == "true"
  }
  project_level_policies = merge(
    local.project_level_list_policies,
    local.project_level_boolean_policies,
    local.project_level_restore_policies
  )
}