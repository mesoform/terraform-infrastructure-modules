data google_project self {
  for_each = toset(var.resources)
  project_id = each.value
}
