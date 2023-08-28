# Technical Challenge
This project is for the technical challenge for Arroyo Consulting, it consists in deploying a containerized application on Amazon Elastic Container Service (ECS) using Terraform. The infrastructure is defined as code, allowing you to provision and manage your ECS resources programmatically.

## Table of Contents

- [Prerequisites](#prerequisites)
- [Getting Started](#getting-started)
- [Project Structure](#project-structure)
- [Terraform Configuration](#terraform-configuration)
- [Deploying the Application](#deploying-the-application)
- [Why ECS?](#why-ecs?)

## Prerequisites

Before you begin, make sure you have the following:

- An AWS account and IAM user with appropriate permissions. (Refer to the policy in ```reference/terraformCI.json``` in order to follow the least privileged access principle)
- Terraform installed on your local machine.
- Docker installed for building and testing your container image.

## Getting Started

1. Clone this repository to your local machine:

   ```bash
   git clone https://github.com/yourusername/ecs-terraform-project.git
   cd technical-challenge/terraform/
   ```
2. Create a ```terraform.tfvars``` file
3. Update the terraform.tfvars file with your desired configuration settings. For reference use the ```terraform.tfvars.example``` file.

## Project Structure
```bash
.
terraform/
├── modules/
│   ├── ec2/              # Module for creating a bastion host
│   │   ├── data.tf
│   │   ├── locals.tf
│   │   ├── main.tf
│   │   └── variables.tf
│   ├── ecs/              # Module for creating a CloudWatch log group, an ECS cluster, service, and tasks
│   │   ├── data.tf
│   │   ├── locals.tf
│   │   ├── main.tf
│   │   ├── outputs.tf
│   │   └── variables.tf
│   ├── elb/              # Module for creating an application load balancer
│   │   ├── locals.tf
│   │   ├── main.tf
│   │   ├── outputs.tf
│   │   └── variables.tf
│   ├── rds/              # Module for creating an RDS instance
│   │   ├── locals.tf
│   │   ├── main.tf
│   │   ├── outputs.tf
│   │   └── variables.tf
│   └── vpc/              # Module for creating a VPC
│       ├── data.tf
│       ├── locals.tf
│       ├── main.tf
│       ├── outputs.tf
│       └── variables.tf
├── templates/
│   ├── ec2/
│   │   └── user_data.tpl  # User data template for creating the EC2 instance
│   ├── task/
│   │   └── container-definitions.json.tpl # Container definitions template for creating the ECS task
├── main.tf               # Main Terraform configuration file where all modules are called
├── Makefile              # Makefile with terraform commands
├── providers.tf          # Provider configuration
├── terraform.tfvars      # CONFIGURE THE VARIABLES HERE
└── variables.tf          # Variable definitions
.gitignore
Dockerfile                # Dockerfile for the app
upload_image.sh           # Commands for uploading the image to the public ECR repo
README.md                 # Project documentation
```
## Terraform Configuration
Configure your AWS credentials by setting environment variables:
```bash
export AWS_ACCESS_KEY_ID="your_access_key"
export AWS_SECRET_ACCESS_KEY="your_secret_key"
export AWS_DEFAULT_REGION="us-east-1"
```
## Deploying the Application
```bash
cd terraform/
make flow
```
## Why ECS?
ECS is a great option for deploying containerized applications. ECS takes care of the complexities of orchestrating containers, such as scheduling, scaling, and managing container instances. It is also simple to configure compared to other container orchestration tools.
