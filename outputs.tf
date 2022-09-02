output "mysql_public_ip_address" {
  value = module.database.public_ip_address
}

output "load_balancer_ip" {
  value = google_compute_global_address.default.address
}
