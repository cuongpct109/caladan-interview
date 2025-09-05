# Caladan Interview Project

This repository contains the source code and infrastructure for the Caladan interview project, including a network latency measurement application and AWS infrastructure managed via Terragrunt/Terraform.

---

## Table of Contents

- [Overview](#overview)
- [Directory Structure](#directory-structure)
- [Latency App](#latency-app)
- [Infrastructure (IAC)](#infrastructure-iac)
- [CI/CD](#cicd)
- [Deployment Guide](#deployment-guide)
- [Additional Information](#additional-information)
- [Internal Documentation](#internal-documentation)

---

## Overview

- **Latency App**: A Flask application that measures network latency to a target host and exposes results via the `/metrics` API and on port 5000.
- **IAC**: AWS infrastructure management (EC2, VPC, Security Group, IAM, etc.) using Terragrunt for modular and reusable Terraform configuration.
- **CI/CD**: GitHub Actions pipelines for automated app build/deploy and infrastructure provisioning.

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

See [apps/README.md](apps/README.md) for details on the application, usage, and API.

---

## Infrastructure (IAC)

See [iac/README.md](iac/README.md) for overall infrastructure documentation.

- [Terraform Modules](iac/_components/aws/README.md)
- [Caladan Environment](iac/envs/caladan/README.md)

---

## CI/CD

See [.github/README.md](.github/README.md) for explanations of all CI/CD pipelines.

---

## Deployment Guide

1. **Prepare AWS and DockerHub credentials**:
    - You need 4 secrets in github actions secrets: 
        - DOCKER_USER, DOCKER_PASSWORD -> these 2 for dockerhub credentials, or any registry that you want, just ensure the network is reachable and you can authenticate successfully in order to push and pull image from it
        - AWS_ACCESS_KEY_ID, AWS_SECRET_ACCESS_KEY -> these 2 you can set it as secrets in an github environment called "aws", or just set it as normal secrets that github action runner can use
        - Read more at [GitHub Workflows](.github/workflows/README.md)
2. **Build & deploy app**:
    - Edit code in `apps/`, push to main → CI/CD auto builds & deploys. 
    - Right now i treat it the same for PR and merge, but can separate it if i have more time, usually i will follow trunked based approach for this enhancement.
    - Read more at [GitHub Workflows](.github/workflows/README.md) and [app cicd workflows](.github/workflows/app.yaml)
3. **Apply infrastructure**:
    - Edit configs in `iac/envs/caladan/`, push → CI/CD auto applies. 
    - There are 2 pipelines, 1 for PR which will run "terragrunt run --all plan" and you can set the individual resource if you want using the input from manual trigger. 
    - The second one is for merge which is same as PR workflow but it will "terragrunt run --all apply"
    - Or apply manually using Terragrunt.
    - Read more at [GitHub Workflows](.github/workflows/README.md), [iac pr workflow](.github/workflows/iac-pr.yaml), [iac merge workflow](.github/workflows/iac-merge.yaml)

---

## Additional Information

- **License**: Apache License 2.0
- **Author**: tranduycuong
- **Tags**: interview, terragrunt, terraform, aws, flask, docker, github-actions

---

## Internal Documentation

- [Latency App Documentation](apps/README.md)
- [Infrastructure Documentation](iac/README.md)
    - [Terraform Modules](iac/_components/aws/README.md)
    - [Caladan AWS environment](iac/envs/caladan/README.md)
- [GitHub Workflows](.github/workflows/README.md)

> For more detailed instructions, see the linked README.md files in each module or email me via cuongpct109@gmail.com