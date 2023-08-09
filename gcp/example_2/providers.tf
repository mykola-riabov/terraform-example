//GCP, TLS
terraform {
  required_providers {
    google = {
      version = "4.77.0"
      source  = "hashicorp/google"
    }
    tls = {
      source = "hashicorp/tls"
      version = "4.0.4"
    }
    local = {
      source = "hashicorp/local"
      version = "2.4.0"
    }
  }
}

provider "google" {
  credentials = var.credentials
  project     = var.project
  region      = var.region
  zone        = var.zone
}
