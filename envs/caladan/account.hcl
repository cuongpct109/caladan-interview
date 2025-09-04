# Set account-wide variables. These are automatically pulled in to configure the remote state bucket in the root
# terragrunt.hcl configuration.
locals {
  account_name   = "caladan-interview-env"
  aws_account_id = "436493931537"
  state_name     = "caladan"
}
