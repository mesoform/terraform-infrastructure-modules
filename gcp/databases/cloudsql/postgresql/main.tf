/**
 * Copyright 2019 Google LLC
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

resource random_id suffix {
  count = var.random_instance_name ? 1 : 0

  byte_length = 4
}

resource google_sql_database_instance default {
  provider            = google-beta
  project             = var.project_id
  name                = local.master_instance_name
  database_version    = var.database_version
  region              = var.region
  encryption_key_name = var.encryption_key_name
  deletion_protection = var.deletion_protection

  settings {
    tier              = var.tier
    activation_policy = var.activation_policy
    availability_type = var.availability_type

    dynamic backup_configuration {
      for_each = [var.backup_configuration]
      content {
        binary_log_enabled             = false
        enabled                        = true
        start_time                     = lookup(backup_configuration.value, "start_time", null)
        location                       = lookup(backup_configuration.value, "location", null)
        point_in_time_recovery_enabled = lookup(backup_configuration.value, "point_in_time_recovery_enabled", false)
        transaction_log_retention_days = lookup(backup_configuration.value, "transaction_log_retention_days", null)

        dynamic backup_retention_settings {
          for_each = local.retained_backups != null || local.retention_unit != null ? [var.backup_configuration] : []
          content {
            retained_backups = local.retained_backups
            retention_unit   = local.retention_unit
          }
        }
      }
    }
    dynamic ip_configuration {
      for_each = [local.ip_configurations[local.ip_configuration_enabled ? "enabled" : "disabled"]]
      content {
        ipv4_enabled       = lookup(ip_configuration.value, "ipv4_enabled", null)
        private_network    = lookup(ip_configuration.value, "private_network", null)
        require_ssl        = lookup(ip_configuration.value, "require_ssl", true)
        allocated_ip_range = lookup(ip_configuration.value, "allocated_ip_range", null)

        dynamic authorized_networks {
          for_each = lookup(ip_configuration.value, "authorized_networks", [])
          content {
            expiration_time = lookup(authorized_networks.value, "expiration_time", null)
            name            = lookup(authorized_networks.value, "name", null)
            value           = lookup(authorized_networks.value, "value", null)
          }
        }
      }
    }
    dynamic insights_config {
      for_each = var.insights_config != null ? [var.insights_config] : []

      content {
        query_insights_enabled  = true
        query_string_length     = lookup(insights_config.value, "query_string_length", 1024)
        record_application_tags = lookup(insights_config.value, "record_application_tags", false)
        record_client_address   = lookup(insights_config.value, "record_client_address", false)
      }
    }

    disk_autoresize       = var.disk_autoresize
    disk_autoresize_limit = var.disk_autoresize_limit
    disk_size             = var.disk_size
    disk_type             = var.disk_type
    pricing_plan          = var.pricing_plan
    dynamic database_flags {
      for_each = local.database_flags
      content {
        name  = database_flags.key
        value = database_flags.value
      }
    }

    user_labels = var.user_labels

    location_preference {
      zone = var.zone
    }

    maintenance_window {
      day          = var.maintenance_window_day
      hour         = var.maintenance_window_hour
      update_track = var.maintenance_window_update_track
    }
  }

  lifecycle {
    ignore_changes = [
      settings[0].disk_size
    ]
  }

  timeouts {
    create = var.create_timeout
    update = var.update_timeout
    delete = var.delete_timeout
  }

  depends_on = [null_resource.module_depends_on]
}

module secret-manager-db-host-ip {
  source = "../../../secret_manager"
  project = var.secret_manager_project_id
  location = var.secret_manager_location
  secret_id = "db-host-ip"
  secret_data = google_sql_database_instance.default.private_ip_address

  depends_on = [null_resource.module_depends_on, google_sql_database_instance.default]
}

module secret-manager-db-server-ca-cert {
  source = "../../../secret_manager"
  project = var.secret_manager_project_id
  location = var.secret_manager_location
  secret_id = "db-server-ca-cert"
  secret_data = google_sql_database_instance.default.server_ca_cert.0.cert
  depends_on = [null_resource.module_depends_on, google_sql_database_instance.default]
}

resource google_sql_database default {
  count      = var.enable_default_db ? 1 : 0
  name       = var.db_name
  project    = var.project_id
  instance   = google_sql_database_instance.default.name
  charset    = var.db_charset
  collation  = var.db_collation
  depends_on = [null_resource.module_depends_on, google_sql_database_instance.default]
}

module secret-manager-db-name {
  source = "../../../secret_manager"
  project = var.secret_manager_project_id
  location = var.secret_manager_location
  secret_id = "db-name"
  secret_data = var.db_name

  depends_on = [null_resource.module_depends_on, google_sql_database.default]
}

resource google_sql_database additional_databases {
  for_each   = local.databases
  project    = var.project_id
  name       = each.value.name
  charset    = lookup(each.value, "charset", null)
  collation  = lookup(each.value, "collation", null)
  instance   = google_sql_database_instance.default.name
  depends_on = [null_resource.module_depends_on, google_sql_database_instance.default]
}

module secret-manager-additional-databases {
  for_each = local.databases
  source = "../../../secret_manager"
  project = var.secret_manager_project_id
  location = var.secret_manager_location
  secret_id = join("-", ["db", each.value.name,])
  secret_data = each.value.name

  depends_on = [null_resource.module_depends_on, google_sql_database.additional_databases]
}

resource google_sql_user default {
  count    = var.enable_default_user ? 1 : 0
  name     = var.user_name
  project  = var.project_id
  instance = google_sql_database_instance.default.name
  password = var.user_password == "" ? random_password.user-password.result : var.user_password
  depends_on = [
    null_resource.module_depends_on,
    google_sql_database_instance.default,
    google_sql_database_instance.replicas,
  ]
}

module secret-manager-db-user {
  source = "../../../secret_manager"
  project = var.secret_manager_project_id
  location = var.secret_manager_location
  secret_id = "db-user"
  secret_data = var.user_name

  depends_on = [null_resource.module_depends_on, google_sql_user.default]
}

resource random_password user-password {
  keepers = {
    name = google_sql_database_instance.default.name
  }

  length     = 32
  special    = false
  depends_on = [null_resource.module_depends_on, google_sql_database_instance.default]
}

module secret-manager-user-password {
  source = "../../../secret_manager"
  project = var.secret_manager_project_id
  location = var.secret_manager_location
  secret_id = "db-password"
  secret_data = random_password.user-password.result

  depends_on = [null_resource.module_depends_on, random_password.user-password]
}

resource google_sql_user additional_users {
  for_each = local.users
  project  = var.project_id
  name     = each.value.name
  password = coalesce(each.value["password"], random_password.additional_passwords[each.value.name].result)
  instance = google_sql_database_instance.default.name
  depends_on = [
    null_resource.module_depends_on,
    google_sql_database_instance.default,
    google_sql_database_instance.replicas,
  ]
}

module secret-manager-additional-users {
  for_each = local.users
  source = "../../../secret_manager"
  project = var.secret_manager_project_id
  location = var.secret_manager_location
  secret_id = join("-", ["db", each.value.name, "user"])
  secret_data = each.value.name

  depends_on = [null_resource.module_depends_on, google_sql_user.additional_users]
}

resource random_password additional_passwords {
  for_each = local.users
  keepers = {
    name = google_sql_database_instance.default.name
  }

  length     = 32
  special    = false
  depends_on = [null_resource.module_depends_on, google_sql_database_instance.default]
}

module secret-manager-additional-passwords {
  for_each = local.users
  source = "../../../secret_manager"
  project = var.secret_manager_project_id
  location = var.secret_manager_location
  secret_id = join("-", ["db", each.value.name, "pass"])
  secret_data = random_password.additional_passwords[each.key].result

  depends_on = [null_resource.module_depends_on, random_password.additional_passwords]
}

resource google_project_iam_member iam_binding {
  for_each = {
    for iu in local.iam_users :
    "${iu.email} ${iu.is_account_sa}" => iu
  }
  project = var.project_id
  role    = "roles/cloudsql.instanceUser"
  member = each.value.is_account_sa ? (
    "serviceAccount:${each.value.email}"
    ) : (
    "user:${each.value.email}"
  )
}

resource google_sql_user iam_account {
  for_each = {
    for iu in local.iam_users :
    "${iu.email} ${iu.is_account_sa}" => iu
  }
  project = var.project_id
  name = each.value.is_account_sa ? (
    trimsuffix(each.value.email, ".gserviceaccount.com")
    ) : (
    each.value.email
  )
  instance = google_sql_database_instance.default.name
  type     = each.value.is_account_sa ? "CLOUD_IAM_SERVICE_ACCOUNT" : "CLOUD_IAM_USER"

  depends_on = [
    null_resource.module_depends_on,
    google_project_iam_member.iam_binding,
  ]
}

resource null_resource module_depends_on {
  triggers = {
    value = length(var.module_depends_on)
  }
}
