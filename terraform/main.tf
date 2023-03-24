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


resource "azurerm_postgresql_server" "wlanglois-pg" {
  name                = "wlanglois-postgresql-server-1"
  location            = data.azurerm_resource_group.rg-wlanglois.location
  resource_group_name = data.azurerm_resource_group.rg-wlanglois.name

  sku_name = "B_Gen5_2"

  storage_mb                   = 5120
  backup_retention_days        = 7
  geo_redundant_backup_enabled = false
  auto_grow_enabled            = true

  administrator_login          = data.azurerm_key_vault_secret.DB-LOGIN.value
  administrator_login_password = data.azurerm_key_vault_secret.DB-PASS.value
  version                      = "11"
  ssl_enforcement_enabled      = true
}

resource "azurerm_postgresql_database" "wlanglois-pgdb" {
  name                = "wlangloisdb"
  resource_group_name = data.azurerm_resource_group.rg-wlanglois.name
  server_name         = azurerm_postgresql_server.wlanglois-pg.name
  charset             = "UTF8"
  collation           = "English_United States.1252"
}

resource "azurerm_postgresql_firewall_rule" "wlanglois-fr" {
  name = "wlangloisfr"
  resource_group_name = data.azurerm_resource_group.rg-wlanglois.name
  server_name = azurerm_postgresql_server.wlanglois-pg.name
  start_ip_address = "0.0.0.0"
  end_ip_address = "0.0.0.0"
}

resource "azurerm_service_plan" "wlanglois-app-plan" {
  name                = "plan-${var.project_name}"
  resource_group_name = data.azurerm_resource_group.rg-wlanglois.name
  location            = data.azurerm_resource_group.rg-wlanglois.location
  os_type             = "Linux"
  sku_name            = "P1v2"
}

resource "azurerm_linux_web_app" "wlanglois-webapp" {
  name                = "web-${var.project_name}"
  resource_group_name = data.azurerm_resource_group.rg-wlanglois.name
  location            = data.azurerm_resource_group.rg-wlanglois.location
  service_plan_id     = azurerm_service_plan.wlanglois-app-plan.id

  site_config {
    always_on = true
    application_stack{
      node_version = "16-lts"
    }
  }

  app_settings = {
    PORT = 3000
    DB_USER = data.azurerm_key_vault_secret.DB-LOGIN.value 
    DB_PASS = data.azurerm_key_vault_secret.DB-PASS.value
    DB_HOST = azurerm_postgresql_server.wlanglois-pg.fqdn
    DB_NAME = azurerm_postgresql_database.wlanglois-pgdb.name
    DB_PORT  = 5432
  }
}

resource "azurerm_container_group" "wlanglois-cg" {
  name="wlanglois-cg"
  resource_group_name = data.azurerm_resource_group.rg-wlanglois.name
  location = data.azurerm_resource_group.rg-wlanglois.location
  ip_address_type = "Public"
  dns_name_label = "wlanglois-cg-dns"
  os_type="Linux"
  exposed_port = []

  container{
    name = "pgadmin"
    image = "dpage/pgadmin4:latest"
    cpu = "0.5"
    memory = "1.5"

    ports{
      port = 80
      protocol = "TCP"
    }

    environment_variables = {
      "PGADMIN_DEFAULT_EMAIL" = data.azurerm_key_vault_secret.PGADMIN-DEFAULT-EMAIL.value
      "PGADMIN_DEFAULT_PASSWORD" = data.azurerm_key_vault_secret.PGADMIN-DEFAULT-PASSWORD.value
      "PGADMIN_CONFIG_ENHANCED_COOKIE_PROTECTION"="False" //Tentative pour fix une erreur de token CSRF sur le pgadmin
    }
  }  
}

