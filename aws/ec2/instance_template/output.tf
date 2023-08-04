output "launch_template_id" {
  value = aws_launch_template.self.id
}
output "launch_template_version" {
  value = aws_launch_template.self.latest_version
}
