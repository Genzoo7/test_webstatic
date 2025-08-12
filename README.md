static-website/
│
├── backend.tf                   # Remote backend
├── providers.tf                 # AzureRM provider + versions
├── variables.tf                 # Shared vars
├── terraform.tfvars             # Non-sensitive overrides
├── main.tf                      # Root module orchestration
├── outputs.tf                   # Root outputs
├── README.md
│
└── modules/
    ├── storage-static-website/
    │   ├── main.tf
    │   ├── variables.tf
    │   ├── outputs.tf
    │   └── versions.tf
    │
    ├── cdn/
    │   ├── main.tf
    │   ├── variables.tf
    │   ├── outputs.tf
    │   └── versions.tf


# Static Website on Azure via Terraform

## Structure
- **modules/storage-static-website** – Storage account + static site hosting
- **modules/cdn** – Azure CDN profile + endpoint
- **backend.tf** – Remote state backend
- **main.tf** – Root orchestration

## Prerequisites
- Terraform >= 1.5
- Azure CLI logged in (`az login`)
- Existing Azure Storage account for remote state and Azure Resource Group

## Deploy
```bash
export TF_VAR_resource_group_name="<your-resource_group_name>"
export TF_VAR_storage_account_name="<your-storage-account-name>"

terraform init
terraform plan
terraform apply
