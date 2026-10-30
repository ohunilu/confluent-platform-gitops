variable "azure_subscription_id" {
  description = "Azure Subscription ID used for Confluent Private Link access"
  type        = string
}

variable "confluent_organization_id" {
  description = "Confluent Cloud Organization ID (from Administration → Organization Settings)"
  type        = string
}