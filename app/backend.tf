terraform {
  required_version = ">= 1.0"

  backend "gcs" {
    bucket = "tlav-bucket" 
    prefix = "terraform/app/state"
  }
}
