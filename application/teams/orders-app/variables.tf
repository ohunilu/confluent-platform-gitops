variable "kafka_admin_api_key" {
  description = "Kafka API key for the topic/ACL admin (bootstrap key)"
  type        = string
  sensitive   = true
}

variable "kafka_admin_api_secret" {
  description = "Kafka API secret for the topic/ACL admin"
  type        = string
  sensitive   = true
}

variable "schema_registry_api_key" {
  description = "Schema Registry API key for schema management"
  type        = string
  sensitive   = true
}

variable "schema_registry_api_secret" {
  description = "Schema Registry API secret"
  type        = string
  sensitive   = true
}