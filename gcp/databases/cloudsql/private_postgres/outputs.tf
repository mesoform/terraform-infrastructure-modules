output cloudsql_connection {
  value       = module.cloudsql-postgres.instance_connection_name
  description = "The connection name of the CloudSQL instance to be used in connection strings"
}

output read_replica_instance_names {
  description = "The names of the read replica instances."
  value       = module.cloudsql-postgres.read_replica_instance_names
}

output read_replica_instance_connection_names {
  description = "The connection names of the read replica instances, for use in connection strings."
  value       = module.cloudsql-postgres.read_replica_instance_connection_names
}