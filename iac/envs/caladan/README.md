# Caladan Environment

This directory contains Terragrunt configuration files for the `caladan` environment.

## Structure

- `account.hcl`, `env.hcl`, `region.hcl`: Environment and region settings.
- Resource folders: `server-1`, `server-2`, `ip-fetcher`, `vpc`, etc.

## Usage

Apply resources individually:

```sh
cd <resource>
terragrunt apply
```

Or use CI/CD pipelines for automated provisioning.

---