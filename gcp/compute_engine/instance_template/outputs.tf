output "self_link" {
  description = "Self-link of instance template"
  value       = {for zone, template in google_compute_instance_template.tpl : zone => template.self_link}
}

output "name" {
  description = "Name of instance template"
  value       = {for zone, template in google_compute_instance_template.tpl : zone => template.name}
}

output "tags" {
  description = "Tags that will be associated with instance(s)"
  value       = {for zone, template in google_compute_instance_template.tpl : zone => template.tags}
}

output "id" {
  description = "Tags that will be associated with instance(s)"
  value       = {for zone, template in google_compute_instance_template.tpl : zone => template.id}
}