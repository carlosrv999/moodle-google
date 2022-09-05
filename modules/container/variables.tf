variable "region" {
  type = string
}

variable "network_name" {
  type = string
}

variable "subnet_names" {
  type = list(string)
}

variable "project_id" {
  type = string
}

variable "instance_type" {
  type    = string
  default = "n2-standard-2"
}

variable "artifact_registry_repo_name" {
  type = string
}
