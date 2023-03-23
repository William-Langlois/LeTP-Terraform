terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "3.48.0"
    }
  }

  backend "azurerm" {
    
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_service_plan" "wlanglois-app-plan" {
  name                = "plan-${var.project_name}${var.environment_suffix}"
  resource_group_name = data.azurerm_resource_group.rg-maalsi.name
  location            = data.azurerm_resource_group.rg-maalsi.location
  os_type             = "Linux"
  sku_name            = "P1v2"
}

resource "azurerm_linux_web_app" "wlanglois-webapp" {
  count               = var.environment_suffix == "-dev" ? 1 : 0    # n'est créé qu'en env de dev
  name                = "web-${var.project_name}${var.environment_suffix}"
  resource_group_name = data.azurerm_resource_group.rg-maalsi.name
  location            = data.azurerm_resource_group.rg-maalsi.location
  service_plan_id     = azurerm_service_plan.app-plan.id

  site_config {}
}