locals {
  common_tags = {
    project = var.project
  }
}

module "storage" {
  source              = "./modules/storage-static-website"
  location            = var.location
  resource_group_name = var.resource_group_name
  resource_prefix     = var.resource_prefix
  index_html_content  = var.index_html_content
  tags                = local.common_tags
}

module "cdn" {
  source              = "./modules/cdn"
  location            = var.location
  resource_group_name = var.resource_group_name
  resource_prefix     = var.resource_prefix
  origin_hostname     = module.storage.primary_web_endpoint
  tags                = local.common_tags
}
