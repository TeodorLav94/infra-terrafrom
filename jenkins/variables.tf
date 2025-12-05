variable "project_id" {
  type = string
  default = "gd-gcp-gridu-devops-t1-t2"
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
  default = "tlavric-vpc"
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
  default = "84.232.193.167/32"
}

variable "vm_ssh_public_key" {
  description = "SSH public key used to access VMs"
  type        = string
  default    = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCLwA+EN6BtuHDbPvpRRvzx+uEM2hLAMCVKrtK+TH8ky7f3J6Lq0P3JJ9CrT4wb+dEPAyRHt9wCx/ITAa3T/hls3oqSgHqhNTM0fexVmB5Axp4HIqy9SeY6j7I94SOQzKgiZz3ifdlAVk4HHEdUA1Ao9urtvNRbVPDI5np9kxhWiA3LpdsnCH/i0+TPpwkNg/pemqGLiugginwXzLJGB5CsjzDtjXjNuMxJkhNY8JRTnkbDmlqROIGK31kBAuoBxgvLv+XkHCwQWrZdrPa4B1AthyZ6QVrw47z+NJgk5DqHXFH+eV7mOpidE2gp2gD6KkA8iPuYNguolp8uUr0boVXkfrFzOftrpuofpjsy955M4lcw0lamizya5p/ozL+925IcWHX7D3vtXqglNBfFz+YuBkVbFNt9HyeGPTYZH3sGNqW2jSgZP1Xvs8/YBBDuzsJC7jjbbiczKqgUdQyw/g6RdvsmxENGjmF6LhziVOFLtFUDqz+5dljR+Js7DAU4N9gIXc1Bv6OMCiZkTsLPB1S3Q73h+9j59R4CUg0OJCJ0oW17QwiXyNtQLsUAQGPVrxlcddkHwlIU+pXwFrqSJNhMHZutx3H+5w6+v92OBu9lqK7eLmmqrlosC7JGJcftnbIO4HEg/ryNUl961Bwx0TNohcwce8rTAa39iz3MhMGO5w== tlavric@linux-vm"
}
