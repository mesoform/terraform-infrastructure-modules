output organization_level_policies {
  value = google_organization_policy.self
}
output folder_level_policies {
  value = google_folder_organization_policy.self
}
output project_level_policies {
  value = google_project_organization_policy.self
}
