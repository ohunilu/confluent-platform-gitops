terraform {
  required_providers {
    confluent = {
      source  = "confluentinc/confluent"
      version = "~> 2.91"
    }
  }
}

resource "confluent_schema" "this" {
  schema_registry_cluster {

    id = var.schema_registry_cluster_id

  }

  rest_endpoint = var.rest_endpoint 
  subject_name  = var.subject_name
  format        = "AVRO"
  schema        = var.schema_content

  credentials {
    key    = var.schema_registry_api_key
    secret = var.schema_registry_api_secret
  }

  lifecycle {
    prevent_destroy = true
  }
}