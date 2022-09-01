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
  database_version         = "MYSQL_5_7"
  home_ip_address          = var.home_ip_address
  instance_name            = "moodledb-03"
  network_id               = module.network.network_id
  instance_specs           = var.database_specs
  private_address_name     = "global-address-moodledb"
  region                   = var.region
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
