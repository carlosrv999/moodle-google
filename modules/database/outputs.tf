output "public_ip_address" {
  value = google_sql_database_instance.default.public_ip_address
}
