resource "google_artifact_registry_repository" "docker_repo" {
  location      = var.region
  repository_id = "petclinic"
  format        = "DOCKER"
  description   = "Docker repo for Spring Petclinic"
}
