# Infrastructure as Code (IAC)

This directory contains all Terraform and Terragrunt configurations for provisioning AWS infrastructure for the Caladan Interview Project.

## Structure

- `_components/`: Reusable Terraform modules (EC2, VPC, IP fetcher, etc.)
- `envs/caladan/`: Environment-specific Terragrunt configurations.

## Usage

- Use Terragrunt to apply infrastructure changes:
    ```sh
    cd envs/caladan/<resource>
    terragrunt apply
    ```

- Infrastructure is also managed via CI/CD pipelines in `.github/workflows/`.

## Main Resources

- `server-1`: EC2 instance running the Latency App.
- `server-2`: EC2 instance as latency measurement target.
- `vpc`: Default VPC and subnet management.

---