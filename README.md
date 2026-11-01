# confluent-platform-gitops

Terraform-driven deployment of Confluent Cloud on Azure DevOps, with Dynatrace observability.

## Repository Structure

- `platform/` — Core Confluent Cloud platform (environments, clusters, networking, RBAC, audit, Schema Registry, ksqlDB)
- `application/` — Application-level resources (topics, schemas, ACLs) per team
- `observability/` — Dynatrace monitoring and dashboard configuration
- `.azuredevops/pipelines/` — Azure DevOps pipeline definitions

## Current Status

### Stage 1 — Foundation

- Git repository with enterprise folder structure
- Branch policies on `main` (reviewers, build validation)
- Confluent Cloud service account `sa-terraform-platform` with OrganizationAdmin
- API key/secret stored in Azure DevOps Variable Group `confluent-platform-secrets`
- Azure Blob Storage backend for Terraform state (container: `tfstate`)
- User-assigned Managed Identity `id-terraform-state-backend` granted **Storage Blob Data Contributor**
- Azure DevOps service connection using workload identity federation (secret-less)
- Terraform provider configuration with `use_azuread_auth = true`

### Stage 2 — Platform pipeline

- Azure DevOps pipeline `.azuredevops/pipelines/platform-pipeline.yml` with two stages: **Plan** (auto on merge) and **Apply** (manual approval gate on `confluent-platform-dev` environment)
- Terraform provisions the Confluent Cloud **environment** `platform-dev` with `stream_governance { package = "ESSENTIALS" }`
- Kafka cluster `platform-kafka-cluster` (Basic tier, SINGLE_ZONE, Azure `germanywestcentral`)
- Azure **Private Link** network (`PRIVATELINK`) and `confluent_private_link_access` scoped to the Azure subscription
- **Schema Registry** auto-provisioned via `stream_governance`; queried via `data.confluent_schema_registry_cluster` with `depends_on = [confluent_kafka_cluster.platform]`
- **ksqlDB** cluster `ksqldb-platform` (4 CSU) with dedicated credential identity
- Service accounts `sa-platform-pipeline-stage2` (platform automation) and `sa-ksqldb-cluster` (ksqlDB workload)
- RBAC: `OrganizationAdmin` for the platform pipeline SA (explicit CRN from `TF_VAR_confluent_organization_id`), `CloudClusterAdmin` on the Kafka cluster for the ksqlDB SA
- Pipeline authenticates to the Azure backend using **OIDC** (`ARM_USE_OIDC`, `ARM_OIDC_TOKEN`, `use_oidc = true`, `use_cli = false`) via the `sc-terraform-state-backend-mi` service connection
- All inputs injected via `TF_VAR_*` from `confluent-platform-secrets` variable group: `azure_subscription_id`, `confluent_organization_id`, `TF_STATE_STORAGE_ACCOUNT`
- Note: `KsqlAdmin` role binding intentionally omitted — **Basic tier Kafka clusters do not support resource-level RBAC**; ksqlDB access on Basic uses ACLs/API keys instead

### Stage 3 — Application pipeline

- Azure DevOps pipeline `.azuredevops/pipelines/application-pipeline.yml` with separate Plan and Apply stages, triggered on `application/*` changes only
- Separate Terraform state (`orders-app.tfstate`) in the same `tfstate` container; separate variable group `confluent-application-secrets`; separate environment `confluent-application-dev` with approval gate
- Application Terraform layer reads platform resource IDs via `data.terraform_remote_state.platform` (no hardcoded cluster/environment IDs; no reading of platform state directly)
- Reusable modules under `application/modules/`: `kafka-topic`, `schema`, `acl-binding` — each with its own `required_providers`, `variables.tf`, and `outputs.tf`
- Service accounts `sa-orders-producer` and `sa-orders-consumer` created with dedicated Kafka API keys scoped to the platform cluster
- `orders` topic (6 partitions) and Avro schema `orders-value` (`com.example.orders.Order`) registered against the platform Schema Registry
- 5 ACLs enforce least-privilege access via the Kafka ACL API (Basic tier does not support resource-level RBAC): producer WRITE + DESCRIBE on topic; consumer READ + DESCRIBE on topic; consumer READ on group `orders-consumer-group`
- Pipeline authenticates to Confluent Cloud using a **Cloud API key** (control-plane, owned by `sa-application-admin` with `OrganizationAdmin`); Cluster-scoped keys are used only for data-plane operations (topics, ACLs, schemas)
- Kafka and Schema Registry REST endpoints resolved via `terraform_remote_state.platform` outputs, not hardcoded

**Scope note:** Stage 3 provisions the infrastructure for data flow. No producer or consumer is deployed; the `orders` topic will appear empty in Confluent Cloud Console until an application team connects with `sa-orders-producer` credentials and starts writing. Demonstrating data flow (a sample producer/consumer) is out of scope for this stage.

### ⏳ Stage 4 — Dynatrace integration (pending)
