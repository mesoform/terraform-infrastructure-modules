variable google_directory_customer_id {
  type = string
}
variable google_directory_group_id {
  type = string
  default = "a-development@mesoform.com"
}

module cloud_identity_group {
  source = "../../../../gcp/resource-manager/cloud_identity_group"
  google_directory_customer_id = var.google_directory_customer_id
  google_directory_group_id = var.google_directory_group_id
  google_directory_group_name = "testing managing CI Groups"
}

module cloud_identity_group_members {
  source = "../../../../gcp/resource-manager/cloud_identity_group_membership"
  google_directory_group_id = module.cloud_identity_group.google_groups_uid
  google_directory_group_members = {
    "mr-wendal@mesoform.com": ["MANAGER", "OWNER", "MEMBER"]
    "mr-dole@mesoform.com": ["MEMBER"]
  }
}