# Caladan Interview Project

This repository contains the source code and infrastructure for the Caladan interview project, including a network latency measurement application and AWS infrastructure managed via Terragrunt/Terraform.

---

## Table of Contents

- [Overview](#overview)  
- [Directory Structure](#directory-structure)  
- [Latency App](#latency-app)  
- [Infrastructure (IAC)](#infrastructure-iac)  
- [CI/CD](#cicd)  
- [Container Orchestration](#container-orchestration)  
- [Tech Stack](#tech-stack)  
- [Deployment Guide](#deployment-guide)  
- [Additional Information](#additional-information)  
- [Internal Documentation](#internal-documentation)  

---

## Overview

- **Latency App**: A Flask application that measures network latency to a target host and exposes results via the `/metrics` API on port 5000.  
- **IAC**: AWS infrastructure management (EC2, VPC, Security Groups, IAM, etc.) using Terragrunt for modular and reusable Terraform configuration.  
- **CI/CD**: GitHub Actions pipelines for automated application build, deployment, and infrastructure provisioning.  

---

## Directory Structure

```
.
├── apps/                   # Latency measurement Flask app source code
│   ├── main.py
│   ├── requirements.txt
│   └── Dockerfile
│   └── README.md           # [Latency App Documentation](apps/README.md)
├── iac/                    # Infrastructure as Code (Terragrunt/Terraform)
│   ├── terragrunt.hcl
│   ├── components/
│   │   └── aws/
│   │       ├── README.md       # [Terraform Modules Documentation](iac/_components/aws/README.md)
│   └── envs/
│       └── caladan/
│           ├── README.md   # [Caladan Environment Documentation](iac/envs/caladan/README.md)
├── .github/
│   ├── workflows/
│   │   ├── app.yaml
│   │   ├── iac-pr.yaml
│   │   └── iac-merge.yaml
│   └── README.md           # [GitHub Workflows Documentation](.github/README.md)
├── README.md               # This documentation
├── LICENSE
└── .gitignore
```

---

## Latency App

- Implements a Flask API to measure network latency.  
- Exposes `/metrics` endpoint on port 5000.  
- Dockerized for deployment.

- See [Latency App Documentation](apps/README.md) for more details.

---

## Infrastructure (IAC)

- Managed using Terragrunt/Terraform.  
- Includes EC2, VPC, Security Groups, IAM, and other AWS resources.  
- Modular, reusable configuration for different environments.  

- See [IAC Documentation](iac/README.md) for full details:  
    - [Terraform Modules](iac/_components/aws/README.md)  
    - [Caladan Environment](iac/envs/caladan/README.md)  

---

## CI/CD

- **CI**: Checkout → Build Docker image → Cache → Push to registry.  
- **CD**: Deploy → Validate → Rollback (if validation fails).  
- See [GitHub Workflows Documentation](.github/workflows/README.md).  

---

## Container Orchestration

- Using **Docker Swarm** with 2 replicas for high availability.  
- Supports **rolling updates** to ensure zero downtime.  
- Automatic cleanup of old images handled via CI/CD workflow.  
- See [App CI/CD Workflow](.github/workflows/app.yaml) for implementation details.  
- Reference: [Docker Swarm Official Documentation](https://docs.docker.com/engine/swarm/).  

---

## Tech Stack

1. Terraform (>= 1.3.0)  
2. Terragrunt (0.86.2)  
3. AWS (EC2, VPC, IAM, etc.)  
4. Docker Swarm  
5. GitHub Actions  

---

## Deployment Guide

1. **Prepare AWS and Docker Registry credentials**:  
   - GitHub secrets required: `DOCKER_USER`, `DOCKER_PASSWORD`, `AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY`.  
   - ⚠ Ensure secrets are correctly set before deploying.  

2. **Initialize AWS infrastructure**:  
   - Edit configuration in `iac/envs/caladan/` and push → CI/CD auto-applies.  
   - Two workflows:  
     - PR workflow: `terragrunt run --all plan`  
     - Merge workflow: `terragrunt run --all apply`  
   - Can also run Terragrunt manually.  

3. **Build & deploy app**:  
   - Edit code in `apps/`, push to main → CI/CD automatically builds & deploys.  
   - Currently, the same workflow is used for PRs and merges; can be separated in future enhancements.  

---

## Additional Information

- **License**: Apache License 2.0  
- **Author**: tranduycuong  
- **Tags**: interview, terragrunt, terraform, aws, flask, docker, github-actions  

---

## Internal Documentation

- [Latency App Documentation](apps/README.md)  
- [Infrastructure As Code Documentation](iac/README.md)  
  - [Terraform Modules](iac/_components/aws/README.md)  
  - [Caladan AWS Environment](iac/envs/caladan/README.md)  
- [GitHub Workflows](.github/workflows/README.md)  

> For more details, see the linked README files in each module or contact cuongpct109@gmail.com  
