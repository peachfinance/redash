resource "google_sql_database_instance" "redash-external" {
  database_version     = "POSTGRES_13"
  deletion_protection  = true
  encryption_key_name  = null
  instance_type        = "CLOUD_SQL_INSTANCE"
  master_instance_name = null
  name                 = "redash-external"

  settings {
    activation_policy           = "ALWAYS"
    availability_type           = "REGIONAL"
    collation                   = null
    connector_enforcement       = "NOT_REQUIRED"
    deletion_protection_enabled = true
    disk_autoresize             = true
    disk_autoresize_limit       = 0
    disk_type                   = "PD_SSD"
    edition                     = null
    pricing_plan                = "PER_USE"
    tier                        = "db-custom-1-3840"
    time_zone                   = null
    user_labels = {
      env = var.env
    }
    backup_configuration {
      enabled                        = true
      point_in_time_recovery_enabled = true
      start_time                     = "13:00"
      transaction_log_retention_days = 7
      backup_retention_settings {
        retained_backups = 7
        retention_unit   = "COUNT"
      }
    }
    ip_configuration {
      allocated_ip_range                            = null
      enable_private_path_for_google_cloud_services = false
      ipv4_enabled                                  = true
      private_network                               = var.private_network
      require_ssl                                   = true
    }

    database_flags {
      name  = "cloudsql.iam_authentication"
      value = "on"
    }
    database_flags {
      name  = "cloudsql.enable_pglogical"
      value = "on"
    }
    database_flags {
      name  = "cloudsql.logical_decoding"
      value = "on"
    }
  }
  timeouts {
    create = null
    delete = null
    update = null
  }
}

resource "google_sql_database_instance" "redash-internal" {
  database_version     = "POSTGRES_13"
  deletion_protection  = true
  encryption_key_name  = null
  instance_type        = "CLOUD_SQL_INSTANCE"
  master_instance_name = null
  name                 = "redash-internal"

  settings {
    activation_policy           = "ALWAYS"
    availability_type           = "REGIONAL"
    collation                   = null
    connector_enforcement       = "NOT_REQUIRED"
    deletion_protection_enabled = true
    disk_autoresize             = true
    disk_autoresize_limit       = 0
    disk_type                   = "PD_SSD"
    edition                     = null
    pricing_plan                = "PER_USE"
    tier                        = "db-custom-1-3840"
    time_zone                   = null
    user_labels = {
      env = var.env
    }
    backup_configuration {
      enabled                        = true
      point_in_time_recovery_enabled = true
      start_time                     = "12:00"
      transaction_log_retention_days = 7
      backup_retention_settings {
        retained_backups = 7
        retention_unit   = "COUNT"
      }
    }
    ip_configuration {
      allocated_ip_range                            = null
      enable_private_path_for_google_cloud_services = false
      ipv4_enabled                                  = false
      private_network                               = var.private_network
      require_ssl                                   = true
    }

    database_flags {
      name  = "cloudsql.iam_authentication"
      value = "on"
    }
    database_flags {
      name  = "cloudsql.enable_pglogical"
      value = "on"
    }
    database_flags {
      name  = "cloudsql.logical_decoding"
      value = "on"
    }
  }
  timeouts {
    create = null
    delete = null
    update = null
  }
}