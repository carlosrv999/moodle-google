output "filestore_private_ip" {
  value = google_filestore_instance.default.networks[0].ip_addresses[0]
}

output "file_share_name" {
  value = google_filestore_instance.default.file_shares[0].name
}
