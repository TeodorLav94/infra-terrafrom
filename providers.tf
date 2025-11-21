# providers.tf
terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 4.0"
    }
    google-beta = { 
      source = "hashicorp/google-beta"
      version = ">= 4.0"
    }
    random = {
      source = "hashicorp/random"
      version = ">= 3.0"
    }
  }
}

provider "google" {
  project = var.project_id
  region  = var.region
  zone    = var.zone
}

provider "google-beta" { 
  project = var.project_id
  region  = var.region
  zone    = var.zone
}
