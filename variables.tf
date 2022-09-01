variable "region" {
  type        = string
  description = "Default region to deploy resources"
}

variable "project_id" {
  type        = string
  description = "Project ID"
}

variable "database_specs" {
  type    = string
  default = "db-n1-standard-2"
}

variable "home_ip_address" {
  type = string
}

variable "gke_node_instance_type" {
  type = string
}
