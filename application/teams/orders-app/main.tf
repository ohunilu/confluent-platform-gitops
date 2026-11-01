# Retrieve remote state from existing platform layer
data "terraform_remote_state" "platform" {
  backend = "azurerm"
  config = {
    resource_group_name  = "VisualStudioOnline-B1A189B4E1B945FF899611833D421FEF"
    storage_account_name = "tfstateconfluent"
    container_name       = "tfstate"
    key                  = "platform.tfstate"
    use_azuread_auth     = true
    use_oidc             = true
    use_cli              = false
  }
}

# Service Accounts
resource "confluent_service_account" "orders_producer" {
  display_name = "sa-orders-producer"
  description  = "Producer service account for the orders topic"
}

resource "confluent_service_account" "orders_consumer" {
  display_name = "sa-orders-consumer"
  description  = "Consumer service account for the orders topic"
}

# Kafka API Keys
resource "confluent_api_key" "orders_producer_kafka" {
  display_name = "orders-producer-kafka-key"
  description  = "Kafka API key for the orders producer"

  owner {
    id          = confluent_service_account.orders_producer.id
    api_version = confluent_service_account.orders_producer.api_version
    kind        = confluent_service_account.orders_producer.kind
  }

  managed_resource {
    id          = data.terraform_remote_state.platform.outputs.kafka_cluster_id
    api_version = "cmk/v2"
    kind        = "Cluster"
    environment {    

      id = data.terraform_remote_state.platform.outputs.environment_id

    }
  }
}

resource "confluent_api_key" "orders_consumer_kafka" {
  display_name = "orders-consumer-kafka-key"
  description  = "Kafka API key for the orders consumer"

  owner {
    id          = confluent_service_account.orders_consumer.id
    api_version = confluent_service_account.orders_consumer.api_version
    kind        = confluent_service_account.orders_consumer.kind
  }

  managed_resource {
    id          = data.terraform_remote_state.platform.outputs.kafka_cluster_id
    api_version = "cmk/v2"
    kind        = "Cluster"
    environment {                                           

      id = data.terraform_remote_state.platform.outputs.environment_id
      
    }
  }
}

# Schema
module "schema" {
  source = "../../modules/schema"

  schema_content             = file("${path.module}/schemas/orders-value.avsc")
  subject_name               = "orders-value"
  schema_registry_cluster_id = data.terraform_remote_state.platform.outputs.schema_registry_id
  rest_endpoint              = data.terraform_remote_state.platform.outputs.schema_registry_rest_endpoint
  schema_registry_api_key    = var.schema_registry_api_key
  schema_registry_api_secret = var.schema_registry_api_secret
}

# Topic
module "kafka_topic" {
  source = "../../modules/kafka-topic"

  topic_name       = "orders"
  cluster_id       = data.terraform_remote_state.platform.outputs.kafka_cluster_id
  rest_endpoint    = data.terraform_remote_state.platform.outputs.kafka_rest_endpoint
  kafka_api_key    = var.kafka_admin_api_key
  kafka_api_secret = var.kafka_admin_api_secret
}

# ACLs
module "acl_binding" {
  source = "../../modules/acl-binding"

  topic_name         = module.kafka_topic.topic_name
  cluster_id         = data.terraform_remote_state.platform.outputs.kafka_cluster_id
  rest_endpoint      = data.terraform_remote_state.platform.outputs.kafka_rest_endpoint
  producer_principal = "User:${confluent_service_account.orders_producer.id}"
  consumer_principal = "User:${confluent_service_account.orders_consumer.id}"
  consumer_group     = "orders-consumer-group"
  kafka_api_key      = var.kafka_admin_api_key
  kafka_api_secret   = var.kafka_admin_api_secret
}