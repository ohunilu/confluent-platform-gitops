terraform {
  required_providers {
    confluent = {
      source  = "confluentinc/confluent"
      version = "~> 2.91"
    }
  }

  backend "azurerm" {
    resource_group_name  = "VisualStudioOnline-B1A189B4E1B945FF899611833D421FEF"
    storage_account_name = "tfstateconfluent"
    container_name       = "tfstate"
    key                  = "platform.tfstate"
    use_oidc             = true
    # Authentication to the storage account is handled by the
    # Azure DevOps service connection / pipeline identity.
  }
}

# The Confluent provider reads CONFLUENT_CLOUD_API_KEY and
# CONFLUENT_CLOUD_API_SECRET from environment variables.
provider "confluent" {}