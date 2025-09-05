# caladan-interview
This repo used to host the source code for Caladan interview project


ngày mai viết iac cicd 
viết readme
tìm kiếm sự liên kết app cicd và iac cicd (kiểu như export biến từ iac ra rồi app cicd dùng chẳng hạn)
còn bước truyền biến khi build để app gọi qua được server 2 nữa

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

---

## Overview

- **Latency App**: A Flask application that measures network latency to a target host and exposes results via the `/metrics` API.
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
├── iac/                    # Infrastructure as Code (Terragrunt/Terraform)
│   ├── terragrunt.hcl      # Root Terragrunt configuration
│   ├── _components/        # Terraform modules (EC2, VPC, IP fetcher, ...)
│   └── envs/               # Deployment environments (caladan)
│       └── caladan/
│           ├── account.hcl
│           ├── env.hcl
│           ├── region.hcl
│           └── ...         # Resources: vpc, server-1, server-2, ip-fetcher
├── .github/workflows/      # CI/CD pipelines for app and IAC
│   ├── app.yaml
│   ├── iac-pr.yaml
│   └── iac-merge.yaml
├── README.md               # This documentation
├── LICENSE                 # Apache License 2.0
└── .gitignore
```

---

## Latency App

- **Purpose**: Measure latency to a target host (e.g., server-2) and expose results via API.
- **Run locally**:
    ```sh
    cd apps
    pip install -r requirements.txt
    python main.py
    ```
- **Docker**:
    ```sh
    docker build -t latency-app .
    docker run -e TARGET_HOST=<ip-server-2> -p 5000:5000 latency-app
    ```
- **API**:
    - `GET /metrics` → returns `{ "latency_ms": <ms>, "status": "ok" }`

---

## Infrastructure (IAC)

- **Managed by Terragrunt/Terraform**:
    - Modular resources: EC2, VPC, IP fetcher, etc.
    - Resource definitions via `terragrunt.hcl` files per environment.
- **Main components**:
    - `server-1`: EC2 instance running Latency App, with public IP.
    - `server-2`: EC2 instance as latency measurement target.
    - `ip-fetcher`: Module to fetch current public IP for security group whitelisting.
    - `vpc`: Default VPC/subnet management module.

- **Apply infrastructure**:
    ```sh
    cd iac/envs/caladan/<resource>
    terragrunt apply
    ```
    (Can also use CI/CD via GitHub Actions)

---

## CI/CD

- **App pipeline** ([.github/workflows/app.yaml](.github/workflows/app.yaml)):
    - Build & push multi-arch Docker image to Docker Hub.
    - Deploy new image to EC2 (`server-1`) via Docker Swarm & AWS SSM.
    - Validate deployment and rollback on failure.

- **IAC pipeline** ([.github/workflows/iac-pr.yaml](.github/workflows/iac-pr.yaml), [.github/workflows/iac-merge.yaml](.github/workflows/iac-merge.yaml)):
    - Automatically run `terragrunt plan` on PR.
    - Automatically run `terragrunt apply` on merge.

---

## Deployment Guide

1. **Prepare AWS credentials** (for local or CI/CD).
2. **Build & deploy app**:
    - Edit code in `apps/`, push to main → CI/CD auto builds & deploys.
    - Or build & run Docker manually as above.
3. **Apply infrastructure**:
    - Edit configs in `iac/envs/caladan/`, push → CI/CD auto applies.
    - Or apply manually using Terragrunt.

---

## Additional Information

- **License**: Apache License 2.0
- **Author**: tranduycuong
- **Tags**: interview, terragrunt, terraform, aws, flask, docker, github-actions

---

> For more detailed instructions, see README.md files in each module or