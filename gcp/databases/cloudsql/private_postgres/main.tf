data "google_compute_network" "main" {
  name = var.vpc_network
  project = var.project_id
}

module "private-service-access" {
  source = "git::https://github.com/terraform-google-modules/terraform-google-sql-db.git//modules/private_service_access?ref=v11.0.0"
  project_id  = var.project_id
  vpc_network = var.vpc_network
  address = var.private_address
}

module "cloudsql-postgres" {
  source = "git::https://github.com/terraform-google-modules/terraform-google-sql-db.git//modules/postgresql?ref=v11.0.0"
  project_id = var.project_id
  name = var.cloudsql_instance_name

  database_version = var.database_version
  region = var.region
  zone = var.zone
  tier = var.cloudsql_instance_tier

  deletion_protection = var.deletion_protection

  database_flags = var.database_flags

  ip_configuration = {
    authorized_networks = []
    ipv4_enabled = false
    private_network = data.google_compute_network.main.id
    require_ssl = true
    allocated_ip_range = module.private-service-access.google_compute_global_address_name
  }

  db_name = var.db_name
  user_name = var.user_name

  additional_users = var.additional_users
  additional_databases = var.additional_databases

  create_timeout = "60m"

  // Optional: used to enforce ordering in the creation of resources.
  module_depends_on = [module.private-service-access.peering_completed]
}
