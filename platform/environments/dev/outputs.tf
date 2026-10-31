output "environment_id" {
  description = "Confluent Cloud environment ID"
  value       = confluent_environment.platform.id
}

output "kafka_cluster_id" {
  description = "Kafka cluster ID"
  value       = confluent_kafka_cluster.platform.id
}

output "kafka_rest_endpoint" {
  description = "Kafka REST endpoint"
  value       = confluent_kafka_cluster.platform.rest_endpoint
}

output "schema_registry_id" {
  description = "Schema Registry cluster ID"
  value       = data.confluent_schema_registry_cluster.main.id
}

output "schema_registry_rest_endpoint" {
  description = "Schema Registry REST endpoint"
  value       = data.confluent_schema_registry_cluster.main.rest_endpoint
}