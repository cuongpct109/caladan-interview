# Include the root `terragrunt.hcl` configuration. The root configuration contains settings that are common across all
# components and environments, such as how to configure remote state.
include "root" {
  path = find_in_parent_folders()
}

terraform {
  source = "${dirname(find_in_parent_folders())}/_components/aws/ec2"
}

dependency "vpc" {
  config_path = "../vpc"
  mock_outputs = {
    default_vpc_id = "vpc-0000000000000"
    default_subnet_ids = [
      "subnet-0aaa1111bbb2222c1",
      "subnet-0aaa1111bbb2222c2",
      "subnet-0aaa1111bbb2222c3",
    ]
  }
}

dependency "my_ip" {
  config_path = "../ip-fetcher"
  mock_outputs = {
    current-public-ip = "1.1.1.1/32"
  }
}

locals {
  # Automatically load environment-level variables
  environment_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))
  # Extract out common variables for reuse
  env = local.environment_vars.locals
}

# ---------------------------------------------------------------------------------------------------------------------
# MODULE PARAMETERS
# ---------------------------------------------------------------------------------------------------------------------
inputs = {
  create_ec2     = true
  image_id       = "ami-003f4a6b343b2086b"
  key_name       = "server-1-key"
  vpc_id         = dependency.vpc.outputs.default_vpc_id
  subnet_ids     = dependency.vpc.outputs.default_subnet_ids
  instance_count = 2
  instance_type  = "t4g.medium"
  instance_name  = "server-1"
  metadata_options = {
    http_endpoint = "enabled"
    http_tokens   = "required"
  }
  root_block_device_mappings = [
    {
      volume_type = "gp3"
      volume_size = 30
      encrypted   = true
    }
  ]
  create_security_group = true
  security_groups = {
    mgmt = {
      name = "mgmt"
      rules = {
        all-outbound = {
          description = "Permit All traffic outbound"
          type        = "egress", from_port = "0", to_port = "0", protocol = "-1"
          cidr_blocks = ["0.0.0.0/0"]
        }
        all-inbound-my-ip-only = {
          description = "Permit all traffic from my current public IP"
          type        = "ingress", from_port = "0", to_port = "0", protocol = "-1"
          cidr_blocks = ["${dependency.my_ip.outputs.current_public_ip}", "10.0.0.0/8"]
        }
        https-inbound = {
          description = "Permit HTTPS"
          type        = "ingress", from_port = "443", to_port = "443", protocol = "tcp"
          cidr_blocks = ["0.0.0.0/0"]
        }
      }
    }
  }
  launch_from_launch_template = false

}
