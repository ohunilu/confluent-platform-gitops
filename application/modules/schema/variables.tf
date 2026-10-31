variable "schema_content" {
  description = "Avro schema definition as a string"
  type        = string
}

variable "subject_name" {
  description = "Schema Registry subject name"
  type        = string
}

variable "schema_registry_cluster_id" {
  description = "Schema Registry cluster ID"
  type        = string
}

variable "rest_endpoint" {
  description = "Schema Registry REST endpoint"
  type        = string
}

variable "schema_registry_api_key" {
  description = "Schema Registry API key"
  type        = string
  sensitive   = true
}

variable "schema_registry_api_secret" {
  description = "Schema Registry API secret"
  type        = string
  sensitive   = true
}