resource "google_filestore_instance" "default" {
  description = "moodledata shared directory for Moodle App"
  labels = {
    "terraform" = "true"
  }
  location = "${var.region}-a"
  name     = var.fileshare_name
  project  = var.project_id
  tier     = var.tier

  file_shares {
    capacity_gb = var.capacity_gb
    name        = var.fileshare_name
  }

  networks {
    connect_mode = "PRIVATE_SERVICE_ACCESS"
    modes = [
      "MODE_IPV4",
    ]
    network = var.network_name
  }
}
