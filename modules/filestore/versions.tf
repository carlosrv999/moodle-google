terraform {
  required_version = ">= 1.2.8"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "4.34.0"
    }
  }
}
