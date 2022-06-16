resource "azurerm_api_management_api" "create_api" {
  name                = "terraform-api"
  resource_group_name = var.RG
  api_management_name = var.APIM
  revision            = "1"
  display_name        = var.api_name
  path                = "terraform"
  service_url          = var.URL    
  subscription_required = false
  protocols           = ["https"]
}

