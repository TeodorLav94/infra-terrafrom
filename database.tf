# database.tf
resource "random_password" "db_root_password" {
  length  = var.db_root_password_length 
  special = false
  upper   = true
  lower   = true
  numeric = true
}

resource "google_sql_database_instance" "mysql_instance" {
  depends_on = [
    google_service_networking_connection.private_vpc_connection
  ]
  
  database_version = "MYSQL_8_0"
  project          = var.project_id
  region           = var.region
  name             = "petclinic-mysql-db"

  settings {
    tier = "db-f1-micro" 
    disk_size = 20
    
    ip_configuration {
      ipv4_enabled = false
      private_network = google_compute_network.vpc.self_link 
    }

    backup_configuration {
      enabled = true
      binary_log_enabled = true
    }
  }

  deletion_protection  = false
}

resource "google_sql_database" "petclinic_db" {
  name     = "petclinic"
  instance = google_sql_database_instance.mysql_instance.name
}

resource "google_sql_user" "petclinic_user" {
  name     = "petclinicuser"
  instance = google_sql_database_instance.mysql_instance.name
  password = random_password.db_root_password.result
}

output "db_user" {
  value = google_sql_user.petclinic_user.name
}

output "db_password" {
  value     = random_password.db_root_password.result
  sensitive = true
}

output "db_private_ip" {
  value       = google_sql_database_instance.mysql_instance.ip_address[0].ip_address
  description = "IP-ul privat al instanței Cloud SQL (Private IP)"
}