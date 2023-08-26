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
	terraform apply

# Destroy Terraform infrastructure
destroy:
	terraform destroy

flow:
	terraform validate
	terraform fmt -recursive
	terraform plan
	terraform apply

# Clean up temporary files and directories
clean:
	rm -rf .terraform terraform.tfstate* .terraform.lock.hcl

.PHONY: init plan apply destroy fmt validate clean