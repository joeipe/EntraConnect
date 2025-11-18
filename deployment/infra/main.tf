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
  site_config {
    minimum_tls_version = "1.2"
    always_on           = false
    application_stack {
      dotnet_version = "8.0"
    }
  }
}
