# Microservices Demo on AWS using ECS Fargate, Terraform, and GitHub Actions

This project is a complete end-to-end deployment of a microservices-based application on AWS.  
It covers containerization, CI, infrastructure provisioning, and automated deployments using real production tooling.

The goal of this project is to demonstrate **practical DevOps skills**, not toy examples.

---

## Architecture Overview

The application is composed of multiple independent microservices deployed as Docker containers on **AWS ECS Fargate**.  
A public **Application Load Balancer (ALB)** exposes the frontend, while internal services communicate using **AWS Cloud Map Service Discovery**.  
Container images are stored in **Amazon ECR**, and the entire infrastructure is provisioned using **Terraform**.  
CI and image builds are automated using **GitHub Actions**.

---

## High-Level Architecture

- AWS VPC with public and private subnets
- Application Load Balancer (public)
- ECS Cluster (Fargate launch type)
- ECS Services for each microservice
- AWS Cloud Map for service discovery
- Amazon ECR for container images
- Terraform for Infrastructure as Code
- GitHub Actions for CI and deployment

---

## Microservices List

| Service Name | Exposure | Description |
|-------------|---------|-------------|
| frontend | Public (ALB) | Web UI |
| cart-service | Internal | Shopping cart |
| checkout-service | Internal | Checkout processing |
| payment | Internal | Payment handling |
| shipping | Internal | Shipping logic |
| product | Internal | Product catalog |
| recommendation-service | Internal | Product recommendations |
| assistant-service | Internal | Shopping assistant |
| currency-service | Internal | Currency conversion |
| email-service | Internal | Email notifications |
| redis-service | Internal | Cache |
| loadgenerator-service | Internal | Load testing |

---

## Container Image Strategy

- Each service has its own Docker image
- Images are built and pushed to **Amazon ECR**
- Image tags use **short Git SHA** for immutability
- ECS task definitions are updated automatically with new tags
 
Example image format:
{ <account-id>.dkr.ecr.us-east-1.amazonaws.com/frontend:<git-sha> }
---

## CI/CD Pipeline (GitHub Actions)

The pipeline runs automatically on every push to the `main` branch.

### detect-changes
- Uses `dorny/paths-filter`
- Detects which services have changed
- Prevents unnecessary builds

### set-version
- Extracts the short Git commit SHA
- Used as the Docker image tag

### codeInteg
- Configures AWS credentials
- Logs in to Amazon ECR
- Creates ECR repositories if they do not exist
- Builds and pushes Docker images only for changed services

### deploy-infra
- Initializes Terraform
- Runs Terraform plan
- Applies infrastructure changes
- Updates ECS services with new container images

This ensures **zero manual deployment steps**.

---

## Infrastructure as Code (Terraform)

Terraform is structured using reusable modules.

### Modules

- **vpc**
  - VPC
  - Public and private subnets
  - Internet Gateway
  - NAT Gateway

- **sg**
  - Security groups for ALB and ECS

- **alb**
  - Application Load Balancer
  - Listener rules
  - Target groups

- **ecs**
  - ECS cluster
  - ECS services
  - Task definitions
  - IAM execution role

- **servicediscovery**
  - AWS Cloud Map namespace
  - Service registrations

- **ecr**
  - Amazon ECR repositories

---

## Deployment Flow

1. Developer pushes code to `main`
2. GitHub Actions triggers
3. Changed services are detected
4. Docker images are built and pushed to ECR
5. Terraform updates ECS services
6. New tasks are deployed automatically

No SSH. No manual steps. No guessing.

---

## Prerequisites

- AWS account
- IAM user with sufficient permissions (Admin for demo)
- AWS CLI configured locally
- Terraform installed (v1.6+)
- GitHub repository with secrets configured

### Required GitHub Secrets

- `AWS_ACCESS_KEY_ID`
- `AWS_SECRET_ACCESS_KEY`

---

## How to Deploy

```bash
git clone <repository-url>
cd microservices-demo
git push origin main

That's it Else Everything is automated

____________________________________ Challenges Faced_____________________________

Common Issues and Fixes
DockerHub Rate Limit Error

Reason: Unauthenticated DockerHub pulls
Fix: Migrated all images to Amazon ECR

CannotPullContainerError

Reason: Image name mismatch between CI and ECS task definition
Fix: Standardized service name and image naming across CI and Terraform

GCP Profiler Issue and Resolution
Problem

While deploying the microservices on AWS ECS, the application logs showed repeated errors related to Google Cloud Profiler. Services were restarting and ECS tasks were unstable.

Investigation
CloudWatch logs revealed profiler initialization errors such as:
Failure to load default Google credentials
Profiler agent unable to start
This indicated that @google-cloud/profiler was attempting to start in an environment where GCP credentials were not available.
Root Cause
Google Cloud Profiler is designed to run only inside GCP environments such as:
GKE
Cloud Run
Compute Engine
This project is deployed on AWS ECS, where:
No GCP metadata server exist
No GCP service account is attached
No GOOGLE_APPLICATION_CREDENTIALs are configured
As a result, the profiler continuously failed and affected service stability.
Fix Applied
The profiler was explicitly disabled for non-GCP environments.
 { name = "DISABLE_PROFILER", value = "1" }  -> added in Payment Task Defination

Target Group Unhealthy
Reason: Container port mismatch or app not listening
Fix: Aligned containerPort, health check path, and ALB target group

Cost Awareness
This project uses real AWS resources.
Main cost drivers:
NAT Gateway
Application Load Balancer
ECS Fargate tasks
Recommendation:
Destroy infrastructure when not in use
Avoid leaving NAT Gateways running unnecessarily
Future Improvements
Blue/Green deployments
Canary release
Autoscaling policies
Observability with Prometheus and Grafana
Secrets management using AWS Secrets Manager


This Repo is Manage By **Rohit Neel Mishra**
