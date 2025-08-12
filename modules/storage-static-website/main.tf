resource "azurerm_storage_account" "static" {
  name                     = "${var.resource_prefix}sa"
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  static_website {
    index_document = "index.html"
  }

  tags = var.tags
}

resource "azurerm_storage_blob" "index" {
  name                   = "index.html"
  storage_account_name   = azurerm_storage_account.static.name
  storage_container_name = "$web"
  type                   = "Block"
  source_content         = var.index_html_content
  content_type           = "text/html"
}

resource "azurerm_storage_blob" "error_4xx" {
  name                   = "4xx.html"
  storage_account_name   = azurerm_storage_account.static.name
  storage_container_name = "$web"
  type                   = "Block"
  source                 = "${path.module}/error_pages/4xx.html"
  content_type           = "text/html"
}

resource "azurerm_storage_blob" "error_5xx" {
  name                   = "5xx.html"
  storage_account_name   = azurerm_storage_account.static.name
  storage_container_name = "$web"
  type                   = "Block"
  source                 = "${path.module}/error_pages/5xx.html"
  content_type           = "text/html"
}


