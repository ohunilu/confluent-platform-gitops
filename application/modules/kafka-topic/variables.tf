variable "topic_name" {
  description = "Name of the Kafka topic"
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

variable "kafka_api_key" {
  description = "Kafka API key for topic management"
  type        = string
  sensitive   = true
}

variable "kafka_api_secret" {
  description = "Kafka API secret for topic management"
  type        = string
  sensitive   = true
}