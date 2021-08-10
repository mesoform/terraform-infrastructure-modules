output list {
  value = [
    for project in data.google_project.self:
       project
        if contains(var.project_ids, project.project_id)
  ]

}