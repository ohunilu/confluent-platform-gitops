variable "dynatrace_env_url" {
  description = "Dynatrace environment URL (e.g., https://abc12345.live.dynatrace.com)"
  type        = string
}

variable "dynatrace_paas_token" {
  description = "Dynatrace PaaS token for ActiveGate installation"
  type        = string
  sensitive   = true
}


variable "azure_location" {
  description = "Azure region for the ActiveGate VM"
  type        = string
  default     = "germanywestcentral"
}

variable "resource_group_name" {
  description = "Azure resource group for observability resources"
  type        = string
  default     = "rg-observability"
}