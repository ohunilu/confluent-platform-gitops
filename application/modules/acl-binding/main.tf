terraform {
  required_providers {
    confluent = {
      source  = "confluentinc/confluent"
      version = "~> 2.91"
    }
  }
}

# Producer: WRITE and DESCRIBE on the orders topic
resource "confluent_kafka_acl" "producer_write" {
  kafka_cluster {
    id = var.cluster_id
  }
  resource_type = "TOPIC"
  resource_name = var.topic_name
  pattern_type  = "LITERAL"
  principal     = var.producer_principal
  host          = "*"
  operation     = "WRITE"
  permission    = "ALLOW"
  rest_endpoint = var.rest_endpoint
  credentials {
    key    = var.kafka_api_key
    secret = var.kafka_api_secret
  }
}

resource "confluent_kafka_acl" "producer_describe" {
  kafka_cluster {
    id = var.cluster_id
  }
  resource_type = "TOPIC"
  resource_name = var.topic_name
  pattern_type  = "LITERAL"
  principal     = var.producer_principal
  host          = "*"
  operation     = "DESCRIBE"
  permission    = "ALLOW"
  rest_endpoint = var.rest_endpoint
  credentials {
    key    = var.kafka_api_key
    secret = var.kafka_api_secret
  }
}

# Consumer: READ and DESCRIBE on the orders topic
resource "confluent_kafka_acl" "consumer_read" {
  kafka_cluster {
    id = var.cluster_id
  }
  resource_type = "TOPIC"
  resource_name = var.topic_name
  pattern_type  = "LITERAL"
  principal     = var.consumer_principal
  host          = "*"
  operation     = "READ"
  permission    = "ALLOW"
  rest_endpoint = var.rest_endpoint
  credentials {
    key    = var.kafka_api_key
    secret = var.kafka_api_secret
  }
}

resource "confluent_kafka_acl" "consumer_describe" {
  kafka_cluster {
    id = var.cluster_id
  }
  resource_type = "TOPIC"
  resource_name = var.topic_name
  pattern_type  = "LITERAL"
  principal     = var.consumer_principal
  host          = "*"
  operation     = "DESCRIBE"
  permission    = "ALLOW"
  rest_endpoint = var.rest_endpoint
  credentials {
    key    = var.kafka_api_key
    secret = var.kafka_api_secret
  }
}

# Consumer: READ on the consumer group (replace with your group ID)
resource "confluent_kafka_acl" "consumer_group_read" {
  kafka_cluster {
    id = var.cluster_id
  }
  resource_type = "GROUP"
  resource_name = var.consumer_group
  pattern_type  = "LITERAL"
  principal     = var.consumer_principal
  host          = "*"
  operation     = "READ"
  permission    = "ALLOW"
  rest_endpoint = var.rest_endpoint
  credentials {
    key    = var.kafka_api_key
    secret = var.kafka_api_secret
  }
}