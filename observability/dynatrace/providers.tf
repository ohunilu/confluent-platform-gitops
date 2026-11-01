terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
    dynatrace = {
      source  = "dynatrace-oss/dynatrace"
      version = "~> 1.0"
    }
  }
}

provider "azurerm" {
  features {}
}

provider "dynatrace" {
  dt_env_url   = var.dynatrace_env_url
  dt_api_token = var.dynatrace_api_token
}