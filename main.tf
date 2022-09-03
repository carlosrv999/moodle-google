module "network" {
  source = "./modules/network"

  network_name = "vpc-notesapp"
  public_subnets = [
    "10.100.0.0/21",
  ]
  private_subnets = [
    "10.100.8.0/21",
  ]
  public_subnet_suffix  = "public-project-notesapp"
  private_subnet_suffix = "private-project-notesapp"
  region                = var.region
}

module "database" {
  source = "./modules/database"

  cidr_block               = "10.100.128.0"
  cidr_block_prefix_length = 20
  database_version         = "MYSQL_8_0"
  home_ip_address          = var.home_ip_address
  instance_name            = "moodledb-13"
  network_id               = module.network.network_id
  instance_specs           = var.database_specs
  private_address_name     = "global-address-moodledb"
  region                   = var.region
  db_password              = var.db_password
  db_name                  = var.db_name
  db_user                  = var.db_user
}

module "container" {
  source = "./modules/container"

  network_name                = module.network.network_name
  subnet_names                = module.network.private_subnets_names
  region                      = var.region
  project_id                  = var.project_id
  instance_type               = var.gke_node_instance_type
  artifact_registry_repo_name = var.artifact_registry_repo_name
}

module "filestore" {
  source = "./modules/filestore"

  fileshare_name = "moodledata"
  network_name   = module.network.network_name
  region         = var.region
  project_id     = var.project_id

  depends_on = [
    module.database
  ]
}

resource "google_compute_instance" "db_restore_instance" {
  name         = "restoresql"
  machine_type = "e2-medium"
  zone         = "${var.region}-a"

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2004-lts"
      size  = "20"
      type  = "pd-ssd"
    }
  }

  network_interface {
    network    = module.network.network_name
    subnetwork = module.network.public_subnets_names[0]

    access_config {
    }
  }

  metadata_startup_script = templatefile("${path.module}/templates/initialize_moodle.tftpl", {
    database_ip     = module.database.private_ip_address,
    db_user         = var.db_user,
    database_passwd = var.db_password,
    filestore_ip    = module.filestore.filestore_private_ip,
    db_name         = var.db_name
  })

  tags = ["ssh"]

  service_account {
    scopes = ["cloud-platform"]
  }
}

resource "google_compute_firewall" "default" {
  name    = "ssh-rule-moodle"
  network = module.network.network_name

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = [var.home_ip_address]
  target_tags   = ["ssh"]
}

resource "local_file" "update_config_php" {

  content = templatefile("${path.module}/templates/config.php.tftpl", {
    db_private_ip   = module.database.private_ip_address,
    db_name         = var.db_name,
    db_user         = var.db_user,
    db_password     = var.db_password,
    loadbalancer_ip = module.network.loadbalancer_ip_address,
  })

  filename = "${path.module}/manifests/overlays/development/serverconfig/config.php"

  depends_on = [
    module.database,
    module.network,
  ]

}

resource "local_file" "kustomization_yaml" {

  content = templatefile("${path.module}/templates/kustomization.yaml.tftpl", {
    image_name = var.image_name,
    image_tag  = var.image_tag,
  })

  filename = "${path.module}/manifests/overlays/development/kustomization.yaml"

}

resource "local_file" "pv_moodledata_yaml" {

  content = templatefile("${path.module}/templates/pv-moodledata.yaml.tftpl", {
    file_share_name      = module.filestore.file_share_name,
    filestore_private_ip = module.filestore.filestore_private_ip,
  })

  filename = "${path.module}/manifests/base/tier-sharedfiles/pv-moodledata.yaml"

}

resource "local_file" "gce_ingress_yaml" {

  content = templatefile("${path.module}/templates/gce-ingress.yaml.tftpl", {
    loadbalancer_ip_name = module.network.loadbalancer_ip_name,
  })

  filename = "${path.module}/manifests/base/tier-web/gce-ingress.yaml"

}
