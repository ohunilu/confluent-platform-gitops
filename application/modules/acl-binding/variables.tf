variable "topic_name" {
  description = "Name of the Kafka topic to grant access to"
  type        = string
}

variable "cluster_id" {
  description = "Kafka cluster ID"
  type        = string
}

variable "rest_endpoint" {
  description = "Kafka cluster REST endpoint"
  type        = string
}

variable "producer_principal" {
  description = "Service account principal for the producer (User:sa-...)"
  type        = string
}

variable "consumer_principal" {
  description = "Service account principal for the consumer (User:sa-...)"
  type        = string
}

variable "consumer_group" {
  description = "Consumer group ID the consumer is allowed to read"
  type        = string
}

variable "kafka_api_key" {
  description = "Kafka API key for ACL management"
  type        = string
  sensitive   = true
}

variable "kafka_api_secret" {
  description = "Kafka API secret for ACL management"
  type        = string
  sensitive   = true
}