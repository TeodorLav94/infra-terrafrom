variable "project_id" {
  type = string
  default = "gd-gcp-internship-devops"
}

variable "region" {
  type    = string
  default = "europe-west1"
}

variable "zone" {
  type    = string
  default = "europe-west1-b"
}

variable "network_name" {
  type    = string
  default = "tlav-petclinic-vpc"
}

variable "subnet_cidr" {
  type    = string
  default = "10.10.0.0/16"
}

variable "db_root_password_length" {
  type    = number
  default = 16
}

variable "app_machine_type" {
  type    = string
  default = "e2-small"
}

variable "jenkins_machine_type" {
  type    = string
  default = "e2-small"
}

variable "app_instance_name" {
  type    = string
  default = "tlav-app-vm"
}

variable "jenkins_instance_name" {
  type    = string
  default = "tlav-jenkins-vm"
}

variable "my_ip_cidr" {
  type    = string
  default = "85.204.75.2/32"
}