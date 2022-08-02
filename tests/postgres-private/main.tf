module "private-service-access" {
  source = "../../gcp/cloud_sql/private_service_access"
  project_id  = "cryptotraders-platform-staging"
  vpc_network = "cryptotraders-platform"
  address = "10.250.0.0"
}

module "cloudsql-postgres" {
  source = "../../gcp/cloud_sql/postgresql"
  project_id = "cryptotraders-platform-staging"
  name = "cloudsql-postgres-test"

  database_version = "POSTGRES_14"
  region = "europe-west2"
  zone = "europe-west2-b"
  tier = "db-f1-micro"
  database_flags = [{ name = "max_connections", value = 50 }]

  ip_configuration = {
    authorized_networks = []
    ipv4_enabled = false
    private_network = module.private-service-access.network_id
    require_ssl = true
    allocated_ip_range = module.private-service-access.google_compute_global_address_name
  }

  db_name = "cryptotraders-db-test"
  user_name = "postgres"

  // Optional: used to enforce ordering in the creation of resources.
  module_depends_on = [module.private-service-access.peering_completed]
}
