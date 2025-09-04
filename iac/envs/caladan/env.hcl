# Set common variables for the environment. This is automatically pulled in in the root terragrunt.hcl configuration to
# feed forward to the child modules.
locals {
  module_source       = ""
  master_prefix       = "caladan"
  project             = "interview"

  tags = {
    "environment"         = "personal"
    "managedBy"           = "tranduycuong"
    "owner"               = "tranduycuong"
    "project"             = "interview"
    "terraform"           = "true"
  }
}
