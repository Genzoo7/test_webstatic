terraform {
  backend "azurerm" {
    container_name = "tfstate"
    key            = "static-website.terraform.tfstate"
  }
}
