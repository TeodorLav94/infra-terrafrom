data "google_compute_image" "debian" {
  family  = "debian-12"
  project = "debian-cloud"
}

resource "google_compute_address" "app_static_ip" {
  name   = "tlav-app-static-ip"
  region = var.region
}

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
    network    = data.google_compute_network.vpc.id
    subnetwork = data.google_compute_subnetwork.subnet.id

    access_config {
      nat_ip = google_compute_address.app_static_ip.address
    }
  }

  metadata = {
    ssh-keys = "tlavric:${var.vm_ssh_public_key}"
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

output "app_vm_ip" {
  value = google_compute_address.app_static_ip.address
}