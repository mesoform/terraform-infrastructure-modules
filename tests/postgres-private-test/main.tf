module "private-cloudsql-postgres" {
  source = "../../gcp/databases/cloudsql/private_postgres"
  project_id  = "cryptotraders-platform-test"
  vpc_network = "cryptotraders-platform"
  private_address = "10.240.0.0"
  cloudsql_instance_name = "postgres-test2"
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

  db_name = "cryptotraders-db-test"
  user_name = "postgres"

  additional_users = [
    {
      name     = "cryptotraders"
      password = ""
    }
  ]

  additional_databases = [
    {
      name      = "cryptotraders-db-test2"
      charset   = ""
      collation = ""
    }
  ]
}
