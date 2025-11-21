data "google_compute_image" "debian" {
  family  = "debian-12"
  project = "debian-cloud"
}

# IP static pentru Jenkins VM
resource "google_compute_address" "jenkins_static_ip" {
  name   = "tlav-jenkins-static-ip"
  region = var.region
}

# IP static pentru App VM
resource "google_compute_address" "app_static_ip" {
  name   = "tlav-app-static-ip"
  region = var.region
}


# app VM
resource "google_compute_instance" "app" {
  name         = var.app_instance_name
  machine_type = var.app_machine_type
  zone         = var.zone

  boot_disk {
    initialize_params {
      image = data.google_compute_image.debian.self_link
      size  = 20
    }
  }

  network_interface {
    network    = google_compute_network.vpc.id
    subnetwork = google_compute_subnetwork.subnet.id

    access_config {
      nat_ip = google_compute_address.app_static_ip.address
    }
  }

  metadata = {
    ssh-keys = "tlavric:${file("~/.ssh/id_rsa.pub")}"
  }

  tags = ["http-server", "petclinic-app"]
}

resource "google_compute_instance_group" "app_ig" {
  name = "${var.app_instance_name}-ig"
  zone = var.zone

  instances = [
    google_compute_instance.app.self_link
  ]

  named_port {
    name = "http"
    port = 8080
  }
}

resource "google_compute_disk" "jenkins_data" {
  name  = "tlav-jenkins-data-disk"
  type  = "pd-balanced"
  size  = 30
  zone  = var.zone

  lifecycle {
    prevent_destroy = true
  }
}


# Optional Jenkins VM
resource "google_compute_instance" "jenkins" {
  name         = var.jenkins_instance_name
  machine_type = var.jenkins_machine_type
  zone         = var.zone

  boot_disk {
    initialize_params {
      image = data.google_compute_image.debian.self_link
      size  = 30
    }
  }

  network_interface {
    network    = google_compute_network.vpc.id
    subnetwork = google_compute_subnetwork.subnet.id
    access_config {
      nat_ip = google_compute_address.jenkins_static_ip.address
    }
  }

  attached_disk {
    source = google_compute_disk.jenkins_data.id
  }

  tags = ["jenkins-server"]
}

output "jenkins_vm_ip" {
  value = google_compute_address.jenkins_static_ip.address
}

output "app_vm_ip" {
  value = google_compute_address.app_static_ip.address
}
