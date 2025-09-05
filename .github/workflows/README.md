# GitHub Workflows

This directory contains CI/CD pipeline definitions for the Caladan Interview Project.

## Workflows

### 1. `app.yaml`

- **Purpose:** Build, push, and deploy the Latency App Docker image.
- **Main steps:**
  - Build and push multi-architecture Docker image to Docker Hub.
  - Deploy the new image to EC2 (`server-1`) using Docker Swarm and AWS SSM.
  - Validate deployment and rollback if necessary.
- **Triggers:** On push to `main`, pull requests, and manual dispatch.

### 2. `iac-pr.yaml`

- **Purpose:** Run Terragrunt plan for infrastructure changes on pull requests.
- **Main steps:**
  - Configure AWS credentials.
  - Log in to Docker Hub (public registry).
  - Run `terragrunt plan` for affected modules.
- **Triggers:** On pull requests affecting IAC files and manual dispatch.

### 3. `iac-merge.yaml`

- **Purpose:** Apply infrastructure changes after merging to `main`.
- **Main steps:**
  - Configure AWS credentials.
  - Log in to Docker Hub (public registry).
  - Run `terragrunt apply` for affected modules.
- **Triggers:** On push to `main` affecting IAC files and manual dispatch.

## Required Secrets

- `AWS_ACCESS_KEY_ID`
- `AWS_SECRET_ACCESS_KEY`
- `DOCKER_USERNAME`
- `DOCKER_PASSWORD`
- `GITHUB_TOKEN` (default)

---

For details on each workflow, see the corresponding YAML file in `.github/workflows/