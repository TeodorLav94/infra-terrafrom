data "google_compute_image" "debian" {
  family  = "debian-12"
  project = "debian-cloud"
}

resource "google_compute_address" "jenkins_static_ip" {
  name   = "tlav-jenkins-static-ip"
  region = var.region
}

resource "google_compute_disk" "jenkins_data" {
  name = "jenkins-data-disk"
  type = "pd-standard"
  zone = var.zone
  size = 30
}

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

  attached_disk {
    source = google_compute_disk.jenkins_data.id
  }

  network_interface {
    network    = google_compute_network.vpc.id
    subnetwork = google_compute_subnetwork.subnet.id
    access_config {
      nat_ip = google_compute_address.jenkins_static_ip.address
    }
  }

  service_account {
    email  = "terraform-cicd@gd-gcp-gridu-devops-t1-t2.iam.gserviceaccount.com"
    scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
  }

  metadata = {
    ssh-keys = "tlavric:${var.vm_ssh_public_key}"
  }

  tags = ["jenkins-server"]
}

resource "google_compute_address" "app_static_ip" {
  name   = "tlav-app-static-ip"
  region = var.region
}

output "app_static_ip" {
  value = google_compute_address.app_static_ip.address
}

output "jenkins_vm_ip" {
  value = google_compute_address.jenkins_static_ip.address
}