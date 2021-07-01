data google_organization self {
  domain = var.organization_domain
}

resource google_access_context_manager_access_policy self {
  parent = data.google_organization.self.name
  title  = var.organization_domain
}