variable "network_name" {
  type        = string
  description = "Name of the network"
}

variable "public_subnets" {
  type        = list(string)
  description = "CIDR ranges for public subnets"
  default     = []
}

variable "private_subnets" {
  type        = list(string)
  description = "CIDR ranges for private subnets"
  default     = []
}

variable "public_subnet_suffix" {
  type        = string
  description = "suffix of public subnets"
  default     = "public-tf"
}

variable "private_subnet_suffix" {
  type        = string
  description = "suffix of private subnets"
  default     = "private-tf"
}

variable "region" {
  type        = string
  description = "region to deploy subnets"
}
