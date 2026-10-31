output "topic_name" {
  description = "The name of the created Kafka topic"
  value       = confluent_kafka_topic.this.topic_name
}

output "topic_id" {
  description = "The ID of the created Kafka topic"
  value       = confluent_kafka_topic.this.id
}