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
  home_ip_address          = "38.25.18.114"
  instance_name            = "moodledb-01"
  network_id               = module.network.network_id
  instance_specs           = "db-n1-standard-2"
  private_address_name     = "global-address-moodledb"
  region                   = var.region
}
