resource google_cloud_identity_group self {
  provider = google-beta
  display_name = var.google_directory_group_name
  parent = "customers/${var.google_directory_customer_id}"
  group_key {
    id = var.google_directory_group_id
  }
  labels = {
    "cloudidentity.googleapis.com/groups.discussion_forum" = "",
  }
}
