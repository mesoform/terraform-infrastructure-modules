resource google_cloud_identity_group_membership self {
  provider = google-beta
  group    = var.google_directory_group_id
  for_each = var.google_directory_group_members

  preferred_member_key {
    id = each.key
  }
  dynamic roles {
    for_each = each.value
    content {
      name = roles.value
    }
  }
}
