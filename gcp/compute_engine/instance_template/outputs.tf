output "self_link" {
  description = "Self-link of instance template"
  value       = google_compute_instance_template.self.self_link
}

output "name" {
  description = "Name of instance template"
  value       = google_compute_instance_template.self.name
}

output "tags" {
  description = "Tags that will be associated with instance(s)"
  value       = google_compute_instance_template.self.tags
}

output "id" {
  description = "Tags that will be associated with instance(s)"
  value       = google_compute_instance_template.self.id
}