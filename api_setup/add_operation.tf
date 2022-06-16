provider "azurerm" {
  features {}
}
# resource "azurerm_api_management_api" "get_api" {
#   name                = "terraform-api"
#   resource_group_name = var.RG
#   api_management_name = var.APIM
#   revision            = "1"
#   display_name        = var.api_name
#   path                = "terraform"
#   service_url          = var.URL    
#   subscription_required = false
#   protocols           = ["https"]
# }

resource "azurerm_api_management_api_operation" "get" {
  operation_id        = "get"
  api_name            = var.api_name
  api_management_name = var.APIM
  resource_group_name = var.RG
  display_name        = "get"
  method              = "GET"
  url_template        = "/"

  response {
    status_code = 200
  }
}
resource "azurerm_api_management_api_operation" "get_join" {
  operation_id        = "get_join"
  api_name            = var.api_name
  api_management_name = var.APIM
  resource_group_name = var.RG
  display_name        = "get_join"
  method              = "GET"
  url_template        = "/join"

  response {
    status_code = 200
  }
}

resource "azurerm_api_management_api_operation" "get_list" {
  operation_id        = "get_list"
  api_name            = var.api_name
  api_management_name = var.APIM
  resource_group_name = var.RG
  display_name        = "get_list"
  method              = "GET"
  url_template        = "/list"

  response {
    status_code = 200
  }
}
resource "azurerm_api_management_api_operation" "post" {
  operation_id        = "post"
  api_name            = var.api_name
  api_management_name = var.APIM
  resource_group_name = var.RG
  display_name        = "post"
  method              = "POST"
  url_template        = "/join"

  response {
    status_code = 200
  }
}
  
