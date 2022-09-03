output "mysql_public_ip_address" {
  value = module.database.public_ip_address
}

output "load_balancer_ip" {
  value = google_compute_global_address.default.address
}

output "filestore_private_ip" {
  value = module.filestore.filestore_private_ip
}

output "ssh_instance_public_ip" {
  value = google_compute_instance.db_restore_instance.network_interface[0].access_config[0].nat_ip
}

output "mysql_private_ip_address" {
  value = module.database.private_ip_address
}
