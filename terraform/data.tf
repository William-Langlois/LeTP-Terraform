data "azurerm_resource_group" "rg-wlanglois" {
  name = "rg-${var.project_name}"
}

data "azurerm_key_vault" "kv-wlanglois"{
  name = "kv-wlanglois"
  resource_group_name = data.azurerm_resource_group.rg-wlanglois.name
}

data "azurerm_key_vault_secret" "PGADMIN-DEFAULT-EMAIL"{
  name = "PGADMIN-DEFAULT-EMAIL"
  key_vault_id = data.azurerm_key_vault.kv-wlanglois.id
}

data "azurerm_key_vault_secret" "PGADMIN-DEFAULT-PASSWORD"{
  name = "PGADMIN-DEFAULT-PASSWORD"
  key_vault_id = data.azurerm_key_vault.kv-wlanglois.id
}

data "azurerm_key_vault_secret" "DB-LOGIN"{
  name = "DB-LOGIN"
  key_vault_id = data.azurerm_key_vault.kv-wlanglois.id
}

data "azurerm_key_vault_secret" "DB-PASS"{
  name = "DB-PASS"
  key_vault_id = data.azurerm_key_vault.kv-wlanglois.id
}