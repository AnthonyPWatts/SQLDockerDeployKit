provider "azurerm" {
  features {}
  subscription_id = "e3861b68-a388-47fa-b00c-f4a7f5d2bc4c"
}

variable "sa_password" {
  description = "Database administrator password. SQL Server uses this for the sa account; PostgreSQL uses this for the postgres account."
  type        = string
  sensitive   = true
}

variable "database_provider" {
  description = "Database provider to deploy. Supported values are sqlserver and postgres."
  type        = string
  default     = "sqlserver"

  validation {
    condition     = contains(["sqlserver", "postgres"], lower(var.database_provider))
    error_message = "database_provider must be either sqlserver or postgres."
  }
}

locals {
  provider_key = lower(var.database_provider)
  provider_settings = {
    sqlserver = {
      image                         = "ghcr.io/anthonypwatts/sqldockerdeploykit/database-container:main"
      port                          = 1433
      password_environment_variable = "MSSQL_SA_PASSWORD"
      username                      = "sa"
      database_name                 = "MoviesDB"
    }
    postgres = {
      image                         = "ghcr.io/anthonypwatts/sqldockerdeploykit/database-container-postgres:main"
      port                          = 5432
      password_environment_variable = "POSTGRES_PASSWORD"
      username                      = "postgres"
      database_name                 = "moviesdb"
    }
  }
  selected_provider = local.provider_settings[local.provider_key]
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
    image  = local.selected_provider.image
    cpu    = 0.5
    memory = 2.0

    secure_environment_variables = {
      (local.selected_provider.password_environment_variable) = var.sa_password
    }

    ports {
      port     = local.selected_provider.port
      protocol = "TCP"
    }
  }

  ip_address_type = "Public"
  dns_name_label  = "databasecontainergroup-${random_id.dns_suffix.hex}"
  exposed_port {
    port     = local.selected_provider.port
    protocol = "TCP"
  }
}

resource "random_id" "dns_suffix" {
  byte_length = 4
}

output "container_group_fqdn" {
  description = "Public DNS name assigned to the Azure Container Instance."
  value       = azurerm_container_group.database_container_group.fqdn
}

output "database_provider" {
  description = "Selected database provider."
  value       = local.provider_key
}

output "database_endpoint" {
  description = "Host and port clients can use to connect to the selected database provider."
  value       = "${azurerm_container_group.database_container_group.fqdn}:${local.selected_provider.port}"
}

output "database_name" {
  description = "Default database created by the selected provider image."
  value       = local.selected_provider.database_name
}

output "database_username" {
  description = "Administrator username for the selected provider image."
  value       = local.selected_provider.username
}
