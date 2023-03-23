terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "3.48.0"
    }
    rabbitmq = {
      source  = "cyrilgdn/rabbitmq"
    }
  }

  backend "azurerm" {
    
  }
}

provider "azurerm" {
  features {}
}

provider "rabbitmq" {
  endpoint = "localhost:15672"
  username = "wlangloisadmin"
  password = "p@ssw0rdadmin"
}

resource "azurerm_service_plan" "wlanglois-app-plan" {
  name                = "plan-${var.project_name}"
  resource_group_name = data.azurerm_resource_group.rg-wlanglois.name
  location            = data.azurerm_resource_group.rg-wlanglois.location
  os_type             = "Linux"
  sku_name            = "P1v2"
}

resource "azurerm_linux_web_app" "wlanglois-webapp" {
  count               = 1
  name                = "web-${var.project_name}"
  resource_group_name = data.azurerm_resource_group.rg-wlanglois.name
  location            = data.azurerm_resource_group.rg-wlanglois.location
  service_plan_id     = azurerm_service_plan.wlanglois-app-plan.id
  zip_deploy_file = "./zipDeployments/nodeAPI.zip"
  site_config {}
}

resource "azurerm_postgresql_server" "wlanglois-pg" {
  name                = "wlanglois-postgresql-server-1"
  location            = data.azurerm_resource_group.rg-wlanglois.location
  resource_group_name = data.azurerm_resource_group.rg-wlanglois.name

  sku_name = "B_Gen5_2"

  storage_mb                   = 5120
  backup_retention_days        = 7
  geo_redundant_backup_enabled = false
  auto_grow_enabled            = true

  administrator_login          = "wlangloisadmin"
  administrator_login_password = "p@ssw0rdadmin"
  version                      = "9.5"
  ssl_enforcement_enabled      = true
}

resource "azurerm_postgresql_database" "wlanglois-pgdb" {
  name                = "wlangloisdb"
  resource_group_name = data.azurerm_resource_group.rg-wlanglois.name
  server_name         = azurerm_postgresql_server.wlanglois-pg.name
  charset             = "UTF8"
  collation           = "English_United States.1252"
}