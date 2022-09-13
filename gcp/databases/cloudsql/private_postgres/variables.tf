variable cloudsql_project_id {
  description = "The project ID of the VPC network to peer. This can be a shared VPC host project"
  type        = string
}

variable cloudsql_vpc_network {
  description = "Name of the VPC network to peer"
  type        = string
}

variable cloudsql_private_address {
  description = "First IP address of the IP range to allocate to CLoud SQL instances and other Private Service Access services. If not set, GCP will pick a valid one for you"
  type        = string
  default     = ""
}

variable cloudsql_instance_name {
  type        = string
  description = "The name of the CloudSQL instance"
}

variable cloudsql_database_version {
  description = "The database version to use"
  type        = string
}

variable cloudsql_region {
  type        = string
  description = "The region of the Cloud SQL resources"
  default     = "europe-west2"
}

variable cloudsql_zone {
  type        = string
  description = "The zone for the CloudSQL instance"
}

variable cloudsql_instance_tier {
  description = "The tier for the CloudSQL instance"
  type        = string
  default     = "db-f1-micro"
}

variable cloudsql_deletion_protection {
  description = "Used to block Terraform from deleting a CloudSQL instance"
  type        = bool
  default     = false
}

variable cloudsql_database_flags {
  description = "The database flags for the CloudSQL instance"
  type = list(object({
    name  = string
    value = string
  }))
  default = []
}

variable cloudsql_bckcfg {
  description = "True if backup configuration is enabled"
  type        = bool
  default     = false
}

variable cloudsql_bckcfg_starttime {
  description = "HH:MM format time indicating when backup configuration starts"
  type        = string
  default     = null
}

variable cloudsql_bckcfg_location {
  description = "The region where the backup will be stored"
  type        = string
  default     = null
}

variable cloudsql_bckcfg_pitr {
  description = "True if Point-in-time recovery is enabled. Will restart database if enabled after instance creation. Valid only for PostgreSQL instances"
  type        = bool
  default     = false
}

variable cloudsql_bckcfg_retention_days {
  description = "The number of days of transaction logs we retain for point in time restore, from 1-7"
  type        = string
  default     = null
}

variable cloudsql_bckcfg_retained_bcks {
  description = "Depending on the value of retention_unit, this is used to determine if a backup needs to be deleted. If retention_unit is 'COUNT', we will retain this many backups"
  type        = number
  default     = null
}

variable cloudsql_bckcfg_retention_unit {
  description = "The unit that 'retained_backups' represents. Defaults to COUNT"
  type        = string
  default     = null
}

variable cloudsql_db_name {
  description = "The name of the default database to create"
  type        = string
  default     = "default"
}

variable cloudsql_user_name {
  description = "The name of the default user"
  type        = string
  default     = "default"
}

variable cloudsql_additional_users {
  description = "A list of users to be created in your cluster"
  type = list(object({
    name     = string
    password = string
  }))
  default = []
}

variable cloudsql_additional_databases {
  description = "A list of databases to be created in your cluster"
  type = list(object({
    name      = string
    charset   = string
    collation = string
  }))
  default = []
}

variable secret_manager_project_id {
  type        = string
  description = "The project ID to manage the secrets"
}

variable secret_manager_location {
  type        = string
  description = "The canonical IDs of the location to replicate data. For example: us-east1"
  default     = "europe-west2"
}
