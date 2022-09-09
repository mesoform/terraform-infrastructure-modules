output cloudsql_connection {
  value       = module.cloudsql-postgres.instance_connection_name
  description = "The connection name of the CloudSQL instance to be used in connection strings"
}
