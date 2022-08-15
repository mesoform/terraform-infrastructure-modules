module private-cloudsql-postgres {
  source = "../../gcp/databases/cloudsql/private_postgres"
  project_id  = "project-test"
  vpc_network = "project-vpc"
  private_address = "10.240.0.0"
  cloudsql_instance_name = "postgres-test"
  database_version = "POSTGRES_14"
  region = "europe-west2"
  zone = "europe-west2-b"
  cloudsql_instance_tier = "db-f1-micro"

  deletion_protection = false

  database_flags = [
    {
      name = "max_connections"
      value = 50
    }
  ]

  db_name = "db-test"
  user_name = "default"

  additional_users = [
    {
      name     = "admin"
      password = ""
    }
  ]

  additional_databases = [
    {
      name      = "db-test2"
      charset   = ""
      collation = ""
    }
  ]
}
