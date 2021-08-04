data google_project self {
  for_each = toset(var.project_ids)
  project_id = each.value
}
