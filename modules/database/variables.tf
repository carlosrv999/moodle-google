variable "network_id" {
  type = string
}

variable "cidr_block" {
  type = string
}

variable "private_address_name" {
  type = string
}

variable "cidr_block_prefix_length" {
  type = number
}

variable "region" {
  type        = string
  description = "region to deploy SQL instances"
}

variable "instance_name" {
  type = string
}

variable "database_version" {
  type = string
}

variable "home_ip_address" {
  type = string
}

variable "instance_specs" {
  type = string
}

variable "db_password" {
  type      = string
  sensitive = true
}
