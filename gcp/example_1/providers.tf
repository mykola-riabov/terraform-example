//GCP, TLS
terraform {
  required_providers {
    google = {
      version = "4.16.0"
      source  = "hashicorp/google"
    }
    tls = {
      source = "hashicorp/tls"
      version = "3.3.0"
    }
  }
}

provider "google" {
  credentials = var.credentials
  project     = var.project
  region      = var.region
  zone        = var.zone
}
