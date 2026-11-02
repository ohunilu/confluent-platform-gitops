terraform {
  backend "azurerm" {
    resource_group_name  = "<Azure Resource Group Name>"
    storage_account_name = "tfstateconfluent"
    container_name       = "tfstate"
    key                  = "orders-app.tfstate"
    use_azuread_auth     = true
    use_oidc             = true
    use_cli              = false
  }

  required_providers {
    confluent = {
      source  = "confluentinc/confluent"
      version = "~> 2.91"
    }
  }
}