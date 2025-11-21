
# 2. Health Check (Portul aplicației 8080)
resource "google_compute_health_check" "http_health_check" {
  name               = "petclinic-http-hc"
  timeout_sec        = 5
  check_interval_sec = 5
  http_health_check {
    port = 8080 
    request_path = "/"
  }
}

# 3. Backend Service
resource "google_compute_backend_service" "app_backend" {
  name                  = "tlav-petclinic-backend-service"
  protocol              = "HTTP"
  port_name             = "http"   
  timeout_sec           = 10
  health_checks         = [google_compute_health_check.http_health_check.self_link]
  load_balancing_scheme = "EXTERNAL"

  backend {
    group = google_compute_instance_group.app_ig.self_link
  }
}
# 4. URL Map (Reguli simple)
resource "google_compute_url_map" "url_map" {
  name            = "tlav-petclinic-url-map"
  default_service = google_compute_backend_service.app_backend.self_link
}

# 5. Target HTTP Proxy
resource "google_compute_target_http_proxy" "http_proxy" {
  name    = "tlav-petclinic-http-proxy"
  url_map = google_compute_url_map.url_map.self_link
}

# 6. Global Forwarding Rule (folosește IP-ul static creat în network.tf)
resource "google_compute_global_forwarding_rule" "http_forwarding_rule" {
  name        = "tlav-petclinic-http-forwarder"
  target      = google_compute_target_http_proxy.http_proxy.self_link
  port_range  = "80"
  ip_protocol = "TCP"
}

output "app_url" {
  value       = "http://${google_compute_global_forwarding_rule.http_forwarding_rule.ip_address}"
  description = "URL-ul prin Load Balancer"
}
