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

### ⏳ Stage 2 — Platform pipeline (pending)

### ⏳ Stage 3 — Application pipeline (pending)

### ⏳ Stage 4 — Dynatrace integration (pending)

## Local Development

```bash
cd platform/environments/dev
az login
terraform init
terraform plan