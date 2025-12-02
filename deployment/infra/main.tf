resource "azurerm_resource_group" "main" {
  name     = "rg-${var.application_name}-${var.environment_name}"
  location = var.primary_location
}

resource "azurerm_service_plan" "main" {
  name                = "asp-${var.application_name}-${var.environment_name}"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  os_type             = "Linux"
  sku_name            = "F1"
}

resource "azurerm_linux_web_app" "webapp" {
  name                = "app-${var.application_name}-${var.environment_name}"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  service_plan_id     = azurerm_service_plan.main.id
  depends_on          = [azurerm_service_plan.main]
  https_only          = true
  identity {
    type = "SystemAssigned"
  }
  site_config {
    minimum_tls_version = "1.2"
    always_on           = false
    application_stack {
      dotnet_version = "8.0"
    }
  }
  app_settings = {
    "ASPNETCORE_ENVIRONMENT"          = var.environment_full_name,
    "WEBSITE_ENABLE_SYNC_UPDATE_SITE" = "true",
    "JISecret"                        = "@Microsoft.KeyVault(VaultName=${azurerm_key_vault.main.name};SecretName=JISecret)"
  }
}

data "azurerm_client_config" "current" {
}

resource "azurerm_key_vault" "main" {
  name                     = "kv-${var.application_name}-${var.environment_name}"
  location                 = azurerm_resource_group.main.location
  resource_group_name      = azurerm_resource_group.main.name
  tenant_id                = data.azurerm_client_config.current.tenant_id
  purge_protection_enabled = false

  sku_name                   = "standard"
  rbac_authorization_enabled = true
}
/*
resource "azurerm_role_assignment" "terraform_kv_admin_assignment" {
  scope                = azurerm_key_vault.main.id
  role_definition_name = "Key Vault Administrator"
  principal_id         = data.azurerm_client_config.current.object_id
}

resource "azurerm_role_assignment" "terraform_kv_secrets_officer_assignment" {
  scope                = azurerm_key_vault.main.id
  role_definition_name = "Key Vault Secrets Officer"
  principal_id         = data.azurerm_client_config.current.object_id
}*/

resource "azurerm_role_assignment" "webapp_role_assignment" {
  scope                = azurerm_key_vault.main.id
  role_definition_name = "Key Vault Secrets User"
  principal_id         = azurerm_linux_web_app.webapp.identity[0].principal_id
}

resource "azurerm_key_vault_secret" "webapp_secrets" {
  for_each     = var.secret_names
  name         = each.value
  value        = "initial-placeholder-value"
  key_vault_id = azurerm_key_vault.main.id

  lifecycle {
    ignore_changes = [
      value,
    ]
  }
}
