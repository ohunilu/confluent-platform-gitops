# Service account for the platform pipeline 
resource "confluent_service_account" "platform_pipeline" {
  display_name = "sa-platform-pipeline-stage2"
}

# Service account for ksqlDB to authenticate
resource "confluent_service_account" "ksqldb" {
  display_name = "sa-ksqldb-cluster"
}

# ksqlDB Servie Account needs Kafka cluster access to manage its internal topics
resource "confluent_role_binding" "ksqldb_kafka_admin" {
  principal   = "User:${confluent_service_account.ksqldb.id}"
  role_name   = "CloudClusterAdmin"
  crn_pattern = confluent_kafka_cluster.platform.rbac_crn
} 

# Grant the platform pipeline service account organization admin
resource "confluent_role_binding" "platform_org_admin" {
  principal   = "User:${confluent_service_account.platform_pipeline.id}"
  role_name   = "OrganizationAdmin"
  crn_pattern = "crn://confluent.cloud/organization=${var.confluent_organization_id}"
}

# Grant the ksqlDB service account permission to its own cluster
resource "confluent_role_binding" "ksqldb_admin" {
  principal   = "User:${confluent_service_account.ksqldb.id}"
  role_name   = "KsqlAdmin"
  crn_pattern = confluent_ksql_cluster.main.resource_name
}