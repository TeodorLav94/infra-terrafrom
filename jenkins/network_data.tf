data "google_compute_network" "vpc" {
  name    = var.network_name
  project = var.project_id
}

data "google_compute_subnetwork" "subnet" {
  name    = "${var.network_name}-subnet"
  region  = var.region
  project = var.project_id
}
