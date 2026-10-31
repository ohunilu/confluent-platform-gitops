output "schema_id" {
  description = "The ID of the registered schema"
  value       = confluent_schema.this.id
}

output "subject_name" {
  description = "The subject the schema was registered under"
  value       = confluent_schema.this.subject_name
}