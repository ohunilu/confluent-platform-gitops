# Create the Confluent Cloud Environment
resource "confluent_environment" "platform" {
  display_name = "platform-dev"

  stream_governance {
    package = "ESSENTIALS"
  }
}

# Create the Kafka Cluster
resource "confluent_kafka_cluster" "platform" {
  display_name = "platform-kafka-cluster"
  availability = "SINGLE_ZONE" # MULTI_ZONE will be used for production
  cloud        = "AZURE"
  region       = "germanywestcentral"
  
  environment { 
    id = confluent_environment.platform.id 
    }
  
  basic {}
}

# Create a Private Link Network for secure access
resource "confluent_network" "private-link" {
  display_name     = "azure-private-link-network"
  cloud            = "AZURE"
  region           = "germanywestcentral"
  connection_types = ["PRIVATELINK"]
  
  environment { 
    id = confluent_environment.platform.id 
    }

}

# Create a Private Link Access for Azure Subcription
resource "confluent_private_link_access" "azure" {
  display_name = "azure-private-link-access"

  azure {
    subscription = var.azure_subscription_id  
  }

  environment {
    id = confluent_environment.platform.id
  }

  network {
    id = confluent_network.private-link.id
  }
}

# Create the Schema Registry Cluster
data "confluent_schema_registry_cluster" "main" {
  environment {
    id = confluent_environment.platform.id
  }

  depends_on = [
    confluent_kafka_cluster.platform
  ]
}

# Create the ksqlDB Cluster
resource "confluent_ksql_cluster" "main" {
  display_name = "ksqldb-platform"
  csu          = 4
  kafka_cluster {                          
    id = confluent_kafka_cluster.platform.id
  }

  credential_identity {
    id = confluent_service_account.ksqldb.id
  }

  environment {
    id = confluent_environment.platform.id
  }

  depends_on = [
    data.confluent_schema_registry_cluster.main
  ]
}