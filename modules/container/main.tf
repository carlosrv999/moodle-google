resource "google_service_account" "default" {
  account_id   = "nodes-service-account"
  display_name = "Service Account for GKE nodes"
}

resource "google_artifact_registry_repository_iam_member" "pull_image_permission" {
  project    = var.project_id
  location   = var.region
  repository = var.artifact_registry_repo_name
  role       = "roles/artifactregistry.reader"
  member     = "serviceAccount:${google_service_account.default.email}"
}

resource "google_container_cluster" "default" {
  name                     = "gke-moodle-tf"
  location                 = var.region
  remove_default_node_pool = true
  initial_node_count       = 1
  network                  = var.network_name
  subnetwork               = var.subnet_names[0]
  networking_mode          = "VPC_NATIVE"

  workload_identity_config {
    workload_pool = "${var.project_id}.svc.id.goog"
  }

  logging_config {
    enable_components = [
      "SYSTEM_COMPONENTS",
      "WORKLOADS",
    ]
  }

  ip_allocation_policy {
    cluster_ipv4_cidr_block  = "10.191.0.0/17"
    services_ipv4_cidr_block = "10.191.128.0/21"
  }

  release_channel {
    channel = "REGULAR"
  }

  default_snat_status {
    disabled = false
  }
}

resource "google_container_node_pool" "primary" {
  name       = "node-pool-moodle"
  cluster    = google_container_cluster.default.id
  node_count = 1

  node_config {
    machine_type = var.instance_type

    service_account = google_service_account.default.email
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
  }
}
