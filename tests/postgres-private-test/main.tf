module private-cloudsql-postgres {
  source = "../../gcp/databases/cloudsql/private_postgres"
  cloudsql_project_id  = "project-test"
  cloudsql_vpc_network = "project-test-vpc"
  cloudsql_private_address = "10.240.0.0"
  cloudsql_instance_name = "postgres-test"
  cloudsql_database_version = "POSTGRES_14"
  cloudsql_region = "europe-west2"
  cloudsql_zone = "europe-west2-b"
  cloudsql_instance_tier = "db-f1-micro"
  cloudsql_deletion_protection = false
  cloudsql_database_flags = [
    {
      name = "max_connections"
      value = 50
    }
  ]
  cloudsql_db_name = "db-test"
  cloudsql_user_name = "default"
  cloudsql_additional_users = [
    {
      name     = "admin"
      password = ""
    }
  ]
  cloudsql_additional_databases = [
    {
      name      = "db-test2"
      charset   = ""
      collation = ""
    }
  ]
  secret_manager_project_id = "project-test2"
  secret_manager_location = "europe-west2"
}
