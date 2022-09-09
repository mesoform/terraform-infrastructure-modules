resource google_secret_manager_secret self {
  project = var.project
  secret_id   = var.secret_id
  replication {
    user_managed {
      replicas {
        location = var.location
      }
    }
  }
}

resource google_secret_manager_secret_version self {
  secret = google_secret_manager_secret.self.id
  secret_data = var.secret_data
}
