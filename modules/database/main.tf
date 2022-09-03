resource "google_compute_global_address" "default" {
  name          = var.private_address_name
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  prefix_length = var.cidr_block_prefix_length
  address       = var.cidr_block
  network       = var.network_id
}

resource "google_service_networking_connection" "default" {
  network                 = var.network_id
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.default.name]
}

resource "google_sql_database_instance" "default" {
  name                = var.instance_name
  database_version    = var.database_version
  region              = var.region
  deletion_protection = false

  depends_on = [
    google_service_networking_connection.default
  ]

  settings {
    tier              = var.instance_specs
    availability_type = "ZONAL"
    disk_autoresize   = true
    disk_size         = 10
    disk_type         = "PD_SSD"

    ip_configuration {
      ipv4_enabled    = true
      private_network = var.network_id

      authorized_networks {
        name  = "my-home"
        value = var.home_ip_address
      }
    }

    backup_configuration {
      binary_log_enabled             = true
      enabled                        = true
      location                       = var.region
      point_in_time_recovery_enabled = false
      start_time                     = "20:00"
      transaction_log_retention_days = 7

      backup_retention_settings {
        retained_backups = 7
        retention_unit   = "COUNT"
      }
    }
  }
}

resource "google_sql_database" "moodle" {
  name      = var.db_name
  instance  = google_sql_database_instance.default.name
  charset   = "utf8mb4"
  collation = "utf8mb4_unicode_ci"
}

resource "google_sql_user" "moodle" {
  name     = var.db_user
  instance = google_sql_database_instance.default.name
  password = var.db_password
  type     = "BUILT_IN"
  host     = "%"
}
