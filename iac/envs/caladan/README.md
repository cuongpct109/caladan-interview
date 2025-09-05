# Caladan Environment Configuration

This directory contains Terragrunt configurations for provisioning AWS resources specific to the Caladan environment.

## Structure

- **account.hcl**: Account-level configuration (e.g., AWS account ID, settings).
- **env.hcl**: Environment-level configuration (e.g., environment name, tags).
- **region.hcl**: Region-specific configuration (e.g., AWS region).

### Resource Folders

- **server-1/**: Terragrunt configuration for the EC2 instance running the Latency App.
- **server-2/**: Terragrunt configuration for the EC2 instance used as the latency measurement target.
- **vpc/**: Terragrunt configuration for VPC and networking resources.

## Usage

To apply infrastructure changes for a specific resource, navigate to its folder and run:

```sh
terragrunt apply
```

Example:

```sh
cd server-1
terragrunt apply
```

Infrastructure changes are also managed via CI/CD pipelines in `.github/workflows/`.

---