output "network_id" {
  value = google_compute_network.vpc.id
}

output "network_name" {
  value = google_compute_network.vpc.name
}

output "public_subnets_names" {
  value = google_compute_subnetwork.public[*].name
}

output "private_subnets_names" {
  value = google_compute_subnetwork.private[*].name
}
