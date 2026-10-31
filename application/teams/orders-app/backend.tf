terraform {
  backend "azurerm" {
    resource_group_name  = "VisualStudioOnline-B1A189B4E1B945FF899611833D421FEF"
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