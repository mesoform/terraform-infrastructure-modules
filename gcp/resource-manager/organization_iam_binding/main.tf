resource google_organization_iam_binding map {
  members = var.iam_binding.members
  org_id = var.google_org_id
  role = var.role
  dynamic condition {
    for_each = var.iam_binding.conditions
    content {
      expression = condition.value.expression
      title = condition.value.title
      description = "${condition.value.title} condition on ${var.role}"
    }
  }
}
