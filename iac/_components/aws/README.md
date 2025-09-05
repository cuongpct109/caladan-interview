# AWS Terraform Components

This directory contains reusable Terraform modules for provisioning AWS resources in the Caladan Interview Project.

## Modules

- **ec2/**: Terraform module for creating and managing EC2 instances, including launch templates, security groups, IAM roles, DNS records, and user data scripts.
- **vpc/**: Terraform module for creating and managing VPCs, subnets, and related networking resources.

## Usage

Import these modules in your Terragrunt or Terraform configurations to provision AWS infrastructure.  
Each module contains its own documentation and example usage in its respective `README.md` file.

## Structure

```
aws/
  ec2/    # EC2 instance module
  vpc/    # VPC module
```

Refer to each module's folder for details on variables, outputs, and usage examples.