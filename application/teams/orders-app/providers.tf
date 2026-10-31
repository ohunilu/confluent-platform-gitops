provider "confluent" {
  cloud_api_key    = var.kafka_admin_api_key
  cloud_api_secret = var.kafka_admin_api_secret
}