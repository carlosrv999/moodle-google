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

variable "artifact_registry_repo_name" {
  type = string
}

variable "db_user" {
  type = string
}

variable "db_name" {
  type = string
}

variable "db_password" {
  type      = string
  sensitive = true
}

variable "image_name" {
  type      = string
  sensitive = true
}

variable "image_tag" {
  type = string
}
