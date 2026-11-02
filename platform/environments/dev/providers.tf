terraform {
  required_providers {
    confluent = {
      source  = "confluentinc/confluent"
      version = "~> 2.91"
    }
  }

  backend "azurerm" {
    resource_group_name  = "<Azure Resource Group Name>"
    storage_account_name = "tfstateconfluent"
    container_name       = "tfstate"
    key                  = "platform.tfstate"
    use_oidc             = true
    use_cli              = false
  }
}

# The Confluent provider reads CONFLUENT_CLOUD_API_KEY and
# CONFLUENT_CLOUD_API_SECRET from environment variables.
provider "confluent" {}