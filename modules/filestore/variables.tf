variable "region" {
  type = string
}

variable "project_id" {
  type = string
}

variable "network_name" {
  type = string
}

variable "capacity_gb" {
  type    = number
  default = 1024
}

variable "fileshare_name" {
  type = string
}

variable "tier" {
  type    = string
  default = "BASIC_HDD"
}
