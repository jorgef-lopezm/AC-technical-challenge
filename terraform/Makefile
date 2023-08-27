SHELL := /bin/bash

# Initialize Terraform
init:
	terraform init

# Validate Terraform configuration
validate:
	terraform validate

# Format Terraform configuration
fmt:
	terraform fmt -recursive

# Plan Terraform changes
plan:
	terraform plan

# Apply Terraform changes
apply:
	terraform apply -auto-approve

# Destroy Terraform infrastructure
destroy:
	terraform destroy -auto-approve

flow:
	terraform init
	terraform validate
	terraform fmt -recursive
	terraform plan
	terraform apply -auto-approve

workspace-create:
	terraform workspace new $(name)

workspace-set:
	terraform workspace select $(name)

# Clean up temporary files and directories
clean:
	rm -rf .terraform terraform.tfstate* .terraform.lock.hcl

.PHONY: init plan apply destroy fmt validate clean