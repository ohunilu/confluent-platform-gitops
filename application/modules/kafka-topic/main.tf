terraform {
  required_providers {
    confluent = {
      source  = "confluentinc/confluent"
      version = "~> 2.91"
    }
  }
}

resource "confluent_kafka_topic" "this" {
  kafka_cluster {

    id = var.cluster_id

  }

  topic_name    = var.topic_name
  rest_endpoint = var.rest_endpoint

  credentials {

    key    = var.kafka_api_key

    secret = var.kafka_api_secret

  }

  lifecycle {
    prevent_destroy = true
  }
}