resource "google_compute_network" "vpc" {
  name                    = var.network_name
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "subnet" {
  name          = "${var.network_name}-subnet"
  ip_cidr_range = var.subnet_cidr
  network       = google_compute_network.vpc.id
  region        = var.region
}

resource "google_compute_firewall" "allow_ssh" {
  name    = "${var.network_name}-allow-ssh"
  network = google_compute_network.vpc.name

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
  source_ranges = [
    var.my_ip_cidr,
    var.subnet_cidr
  ]
  target_tags   = ["jenkins-server", "petclinic-app"]
}

resource "google_compute_firewall" "allow_internal_to_jenkins" {
  name    = "${var.network_name}-allow-internal-to-jenkins"
  network = google_compute_network.vpc.name

  allow {
    protocol = "tcp"
    ports    = ["8080"]
  }

  source_ranges = [var.subnet_cidr]

  target_tags = ["jenkins-server"]
}

resource "google_compute_firewall" "allow_jenkins" {
  name    = "${var.network_name}-allow-jenkins"
  network = google_compute_network.vpc.name

  allow {
    protocol = "tcp"
    ports    = ["8080"] 
  }

  source_ranges = [var.my_ip_cidr]
  target_tags   = ["jenkins-server"]
}

resource "google_compute_firewall" "allow_lb_to_app" {
  name    = "${var.network_name}-allow-lb-to-app"
  network = google_compute_network.vpc.name

  allow {
    protocol = "tcp"
    ports    = ["8080"] 
  }

  source_ranges = ["35.191.0.0/16", "130.211.0.0/22"]
  target_tags   = ["petclinic-app"]
}

resource "google_compute_firewall" "allow_icmp" {
  name    = "${var.network_name}-allow-icmp"
  network = google_compute_network.vpc.name

  allow { protocol = "icmp" }
  source_ranges = [var.my_ip_cidr]
  target_tags   = ["jenkins-server", "petclinic-app"]
}
