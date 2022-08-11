output "cloudsql_connection" {
  value       = module.cloudsql-postgres.instance_connection_name
  description = "The connection name of the CloudSQL instance to be used in connection strings"
}

output "default_user_pass" {
  value       = module.cloudsql-postgres.generated_user_password
  description = "The password for the default user"
  sensitive = true
}

output "additional_users" {
  description = "List of maps of additional users and passwords"
  value = [for user in module.cloudsql-postgres.additional_users :
    {
      name     = user.name
      password = user.password
    }
  ]
  sensitive = true
}
