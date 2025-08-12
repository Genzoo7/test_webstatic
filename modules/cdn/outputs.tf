output "endpoint_hostname" {
  value = "https://${azurerm_cdn_frontdoor_endpoint.front_endpoint.host_name}"
}
