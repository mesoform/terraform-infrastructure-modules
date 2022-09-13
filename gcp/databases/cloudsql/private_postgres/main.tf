data google_compute_network main {
  name = var.cloudsql_vpc_network
  project = var.cloudsql_project_id
}

module private-service-access {
  source = "../../../compute_engine/private_service_access"
  project_id  = var.cloudsql_project_id
  vpc_network = var.cloudsql_vpc_network
  address = var.cloudsql_private_address
}

module cloudsql-postgres {
  source = "../postgresql"
  project_id = var.cloudsql_project_id
  name = var.cloudsql_instance_name
  create_timeout = "60m"
  database_version = var.cloudsql_database_version
  region = var.cloudsql_region
  zone = var.cloudsql_zone
  tier = var.cloudsql_instance_tier

  deletion_protection = var.cloudsql_deletion_protection

  database_flags = var.cloudsql_database_flags

  ip_configuration = {
    authorized_networks = []
    ipv4_enabled = false
    private_network = data.google_compute_network.main.id
    require_ssl = true
    allocated_ip_range = module.private-service-access.google_compute_global_address_name
  }

  backup_configuration = {
    enabled = var.cloudsql_bckcfg
    start_time = var.cloudsql_bckcfg_starttime
    location = var.cloudsql_bckcfg_location
    point_in_time_recovery_enabled = var.cloudsql_bckcfg_pitr
    transaction_log_retention_days = var.cloudsql_bckcfg_retention_days
    retained_backups = var.cloudsql_bckcfg_retained_bcks
    retention_unit = var.cloudsql_bckcfg_retention_unit
  }

  db_name = var.cloudsql_db_name
  user_name = var.cloudsql_user_name

  additional_users = var.cloudsql_additional_users
  additional_databases = var.cloudsql_additional_databases

  secret_manager_project_id = var.secret_manager_project_id
  secret_manager_location = var.secret_manager_location

  module_depends_on = [module.private-service-access.peering_completed]
}
