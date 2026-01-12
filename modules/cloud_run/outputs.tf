output "service_url" {
  value = google_cloud_run_v2_service.default.uri
}

output "custom_domain_dns_records" {
  value = try(google_cloud_run_domain_mapping.default[0].status, "No DNS Mapping")
}
