provider "azurerm" {
  features {}
  subscription_id = "e3861b68-a388-47fa-b00c-f4a7f5d2bc4c"
}

resource "azurerm_resource_group" "database_rg" {
  name     = "database-resource-group"
  location = "UK South"
}

resource "azurerm_container_group" "database_container_group" {
  name                = "databasecontainergroup"
  location            = azurerm_resource_group.database_rg.location
  resource_group_name = azurerm_resource_group.database_rg.name
  os_type             = "Linux"
  restart_policy      = "OnFailure"

  container {
    name   = "databasecontainer"
    image  = "ghcr.io/anthonypwatts/sqldockerdeploykit/database-container:main"
    cpu    = 0.5
    memory = 2.0

    ports {
      port     = 1433
      protocol = "TCP"
    }
  }

  ip_address_type = "Public"
  dns_name_label  = "databasecontainergroup-${random_id.dns_suffix.hex}"
  exposed_port {
    port     = 1433
    protocol = "TCP"
  }
}

resource "random_id" "dns_suffix" {
  byte_length = 4
}
