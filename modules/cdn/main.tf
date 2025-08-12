resource "azurerm_cdn_frontdoor_profile" "front_profile" {
  name                = "cdn-profile"
  resource_group_name = var.resource_group_name
  sku_name            = "Standard_AzureFrontDoor"
  tags = var.tags
}

resource "azurerm_cdn_frontdoor_endpoint" "front_endpoint" {
  name                     = "endpoint"
  cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.front_profile.id
  tags = var.tags
}

resource "azurerm_cdn_frontdoor_origin_group" "front_origin_group" {
  name                     = "front-origin-group"
  cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.front_profile.id

  load_balancing {}
}

resource "azurerm_cdn_frontdoor_origin" "front_origin" {
  name                          = "front-origin"
  cdn_frontdoor_origin_group_id = azurerm_cdn_frontdoor_origin_group.front_origin_group.id
  enabled                       = true

  certificate_name_check_enabled = false

  host_name          = trim(replace(var.origin_hostname, "https://", ""), "/")
  http_port          = 80
  https_port         = 443
  origin_host_header = trim(replace(var.origin_hostname, "https://", ""), "/")
  priority           = 1
  weight             = 1
}

resource "azurerm_cdn_frontdoor_rule_set" "front_rs" {
  name                     = "FrontRuleSet"
  cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.front_profile.id
}

resource "azurerm_cdn_frontdoor_route" "front_route" {
  name                          = "front-route"
  cdn_frontdoor_endpoint_id     = azurerm_cdn_frontdoor_endpoint.front_endpoint.id
  cdn_frontdoor_origin_group_id = azurerm_cdn_frontdoor_origin_group.front_origin_group.id
  cdn_frontdoor_origin_ids      = [azurerm_cdn_frontdoor_origin.front_origin.id]
  cdn_frontdoor_rule_set_ids    = [azurerm_cdn_frontdoor_rule_set.front_rs.id]
  enabled                       = true

  forwarding_protocol    = "HttpsOnly"
  https_redirect_enabled = true
  patterns_to_match      = ["/*"]
  supported_protocols    = ["Http", "Https"]

  cache {
    query_string_caching_behavior = "IgnoreSpecifiedQueryStrings"
    query_strings                 = ["account", "settings"]
    compression_enabled           = true
    content_types_to_compress     = ["text/html", "text/javascript", "text/xml"]
  }
}

resource "azurerm_cdn_frontdoor_firewall_policy" "waf_policy" {
  name                              = "wafpolicy"
  resource_group_name               = var.resource_group_name
  sku_name                          = azurerm_cdn_frontdoor_profile.front_profile.sku_name
  enabled                           = true
  mode                              = "Prevention"

  custom_rule {
    name                           = "RateLimitRule"
    enabled                        = true
    priority                       = 1
    rate_limit_duration_in_minutes = 1
    rate_limit_threshold           = 100
    type                           = "RateLimitRule"
    action                         = "Block"
    match_condition {
      match_variable     = "RemoteAddr"
      operator           = "IPMatch"
      negation_condition = false
      match_values = ["0.0.0.0/0"]

    }
  }
}

resource "azurerm_cdn_frontdoor_security_policy" "front_sp" {
  name                     = "front-sp"
  cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.front_profile.id

  security_policies {
    firewall {
      cdn_frontdoor_firewall_policy_id = azurerm_cdn_frontdoor_firewall_policy.waf_policy.id

      association {
        domain {
          cdn_frontdoor_domain_id = azurerm_cdn_frontdoor_endpoint.front_endpoint.id
        }
        patterns_to_match = ["/*"]
      }
    }
  }
}
