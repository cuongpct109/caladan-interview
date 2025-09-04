# AWS EC2 Module

Terraform module which creates EC2 resources on AWS provided by Terraform AWS provider.

## Usage
```hcl
module "ec2" {
  source         = "git@github.com:examplae/ec2.git"
  aws_region    = "ap-southeast-1"
  master_prefix = "dev"
  # assume_role    = "arn:aws:iam::111222333444:role/AWSAFTExecution"
  image_id       = "ami-02453f5468b897e31" # Needed if not launch from template
  key_name       = "example-keypair"
  subnet_ids     = ["subnet-e707d7af", "subnet-3502a253"]
  instance_count = 2
  instance_type  = "t3.micro"
  instance_name  = "test-instance-name"
  root_block_device_mappings = [
    {
      volume_type = "gp3"
      volume_size = 20
      encrypted   = false
      kms_key_id  = null
    }
  ]
  vpc_security_group_ids = ["sg-0a928560674711bd8"]
  security_groups        = {}
  #### Launch template configuration ####
  launch_from_launch_template = true
  create_launch_template      = true
  launch_template_name        = "test-template"
  # template_user_data = "example.sh"
  image_id = "ami-02453f5468b897e31"
  # template_instance_type = "t2.micro"
  ebs_block_device_mappings = [{
    device_name = "/dev/sda1"
    ebs = {
      volume_size = 20
      volume_type = "gp3"
    }
  }]
  vpc_id                           = "vpc-3fdd2259"
  disable_api_termination = true # enables EC2 instance termination protection
  monitoring       = true
  placement = {
    availability_zone = "ap-southeast-1a"
  }
  template_network_interfaces = [{ delete_on_termination = true }]
  iam_instance_profile = {
    name = "ec2-admin-role"
  }
  instance_market_options = {
    market_type = "spot"
    spot_options = {
      spot_instance_type = "persistent"
      instance_interruption_behavior = "stop"
    }
  }
  instance_requirements = {
    memory_mib = {
      min = 1
      max = 3
    }
    total_local_storage_gb = {
      min = 20
      max = 30
    }
    vcpu_count = {
      min = 1
      max = 2
    }
    allowed_instance_types = ["t2.micro", "t3.micro"]
    bare_metal             = "excluded"
  }
  launch_template_tags = {
    Environment = "dev"
  }
  tags = {
    App = "example"
  }
  ### Custom launch template
  # launch_template = {
  #   name    = "test-custom"
  #   version = "6"
  # }
}
```

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.1.0, < 6.0.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 5.1.0, < 6.0.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_security_group"></a> [security\_group](#module\_security\_group) | v1.2.0 |

## Resources

| Name | Type |
|------|------|
| [aws_iam_instance_profile.instance_profile](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_instance_profile) | resource |
| [aws_iam_policy.custom_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_role.instance_profile](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.custom_policy_attachment](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.policy_attachment](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_instance.ec2_instance](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance) | resource |
| [aws_launch_template.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/launch_template) | resource |
| [aws_route53_record.ec2_instance_dns](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |
| [aws_security_group.security_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_iam_policy_document.assume_role_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_partition.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/partition) | data source |
| [aws_subnets.selected](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/subnets) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_launch_template_name"></a> [launch\_template\_name](#input\_launch\_template\_name) | The Name of launch template | `string` | n/a | yes |
| <a name="input_additional_tags"></a> [additional\_tags](#input\_additional\_tags) | Tags to add to the security group resource. | `map(string)` | `{}` | no |
| <a name="input_associate_public_ip_address"></a> [associate\_public\_ip\_address](#input\_associate\_public\_ip\_address) | Associate a public IP address with the instance | `bool` | `false` | no |
| <a name="input_assume_role"></a> [assume\_role](#input\_assume\_role) | AssumeRole to manage the resources within account that owns | `string` | `null` | no |
| <a name="input_availability_zone"></a> [availability\_zone](#input\_availability\_zone) | AZ to start the instance in | `string` | `null` | no |
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | AWS Region name to deploy resources. | `string` | `"ap-southeast-1"` | no |
| <a name="input_bootstrap_options"></a> [bootstrap\_options](#input\_bootstrap\_options) | Bootstrap options to put into userdata | `list(string)` | `[]` | no |
| <a name="input_capacity_reservation_specification"></a> [capacity\_reservation\_specification](#input\_capacity\_reservation\_specification) | Targeting for EC2 capacity reservations | `any` | `null` | no |
| <a name="input_cpu_options"></a> [cpu\_options](#input\_cpu\_options) | The CPU options for the instance | <pre>object({<br>    amd_sev_snp      = optional(string)<br>    core_count       = optional(number)<br>    threads_per_core = optional(number)<br>  })</pre> | `{}` | no |
| <a name="input_create_dns"></a> [create\_dns](#input\_create\_dns) | A boolean flag to add record to route53 | `bool` | `false` | no |
| <a name="input_create_ec2"></a> [create\_ec2](#input\_create\_ec2) | A boolean flag to create EC2 instance | `bool` | `true` | no |
| <a name="input_create_iam_instance_profile"></a> [create\_iam\_instance\_profile](#input\_create\_iam\_instance\_profile) | Determines whether an IAM instance profile is created or to use an existing IAM instance profile | `bool` | `false` | no |
| <a name="input_create_security_group"></a> [create\_security\_group](#input\_create\_security\_group) | A boolean flag to determine whether to create Security Group. | `bool` | `true` | no |
| <a name="input_credit_specification"></a> [credit\_specification](#input\_credit\_specification) | Customize the credit specification of the instance | `map(string)` | `null` | no |
| <a name="input_custom_policy"></a> [custom\_policy](#input\_custom\_policy) | The policy document. This is a JSON formatted string. | `string` | `null` | no |
| <a name="input_disable_api_termination"></a> [disable\_api\_termination](#input\_disable\_api\_termination) | If true, enables EC2 Instance Termination Protection | `bool` | `null` | no |
| <a name="input_dns_zone_id"></a> [dns\_zone\_id](#input\_dns\_zone\_id) | Route53 DNS Zone ID. | `string` | `null` | no |
| <a name="input_dns_zone_ttl"></a> [dns\_zone\_ttl](#input\_dns\_zone\_ttl) | The TTL of the record. | `number` | `60` | no |
| <a name="input_ebs_block_device_mappings"></a> [ebs\_block\_device\_mappings](#input\_ebs\_block\_device\_mappings) | Additional EBS block devices to attach to the instance | `list(any)` | `[]` | no |
| <a name="input_ebs_optimized"></a> [ebs\_optimized](#input\_ebs\_optimized) | If true, the launched EC2 instance will be EBS-optimized | `bool` | `null` | no |
| <a name="input_elastic_gpu_specifications"></a> [elastic\_gpu\_specifications](#input\_elastic\_gpu\_specifications) | The elastic GPU to attach to the instance | `map(string)` | `null` | no |
| <a name="input_elastic_inference_accelerator"></a> [elastic\_inference\_accelerator](#input\_elastic\_inference\_accelerator) | Configuration block containing an Elastic Inference Accelerator to attach to the instance | `map(string)` | `null` | no |
| <a name="input_enclave_options"></a> [enclave\_options](#input\_enclave\_options) | Enable Nitro Enclaves on launched instances | <pre>object({<br>    enabled = optional(bool)<br>  })</pre> | `{}` | no |
| <a name="input_ephemeral_block_device"></a> [ephemeral\_block\_device](#input\_ephemeral\_block\_device) | Customize Ephemeral (also known as Instance Store) volumes on the instance | `list(map(string))` | `[]` | no |
| <a name="input_get_password_data"></a> [get\_password\_data](#input\_get\_password\_data) | If true, wait for password data to become available and retrieve it. | `bool` | `null` | no |
| <a name="input_hibernation_options"></a> [hibernation\_options](#input\_hibernation\_options) | The hibernation options for the instance | `map(string)` | `null` | no |
| <a name="input_iam_instance_profile"></a> [iam\_instance\_profile](#input\_iam\_instance\_profile) | The IAM Instance Profile to launch the instance with | <pre>object({<br>    name = optional(string)<br>    arn  = optional(string)<br>  })</pre> | `{}` | no |
| <a name="input_iam_role_description"></a> [iam\_role\_description](#input\_iam\_role\_description) | Description of the role | `string` | `null` | no |
| <a name="input_iam_role_path"></a> [iam\_role\_path](#input\_iam\_role\_path) | IAM role path | `string` | `null` | no |
| <a name="input_iam_role_permissions_boundary"></a> [iam\_role\_permissions\_boundary](#input\_iam\_role\_permissions\_boundary) | ARN of the policy that is used to set the permissions boundary for the IAM role | `string` | `null` | no |
| <a name="input_iam_role_policies"></a> [iam\_role\_policies](#input\_iam\_role\_policies) | IAM policies to attach to the IAM role | `map(string)` | `{}` | no |
| <a name="input_iam_role_tags"></a> [iam\_role\_tags](#input\_iam\_role\_tags) | A map of additional tags to add to the IAM role created | `map(string)` | `{}` | no |
| <a name="input_image_id"></a> [image\_id](#input\_image\_id) | The AMI to use for the instance. | `string` | `null` | no |
| <a name="input_instance_count"></a> [instance\_count](#input\_instance\_count) | Number of instance to deploy | `number` | `1` | no |
| <a name="input_instance_initiated_shutdown_behavior"></a> [instance\_initiated\_shutdown\_behavior](#input\_instance\_initiated\_shutdown\_behavior) | Shutdown behavior for the instance. Amazon defaults this to stop for EBS-backed instances and terminate for instance-store instances. Cannot be set on instance-store instance | `string` | `null` | no |
| <a name="input_instance_market_options"></a> [instance\_market\_options](#input\_instance\_market\_options) | The market (purchasing) option for the instance | `any` | `null` | no |
| <a name="input_instance_name"></a> [instance\_name](#input\_instance\_name) | Name to be used on EC2 instance created | `string` | `null` | no |
| <a name="input_instance_requirements"></a> [instance\_requirements](#input\_instance\_requirements) | Instance requirement for launch template | `any` | `null` | no |
| <a name="input_instance_type"></a> [instance\_type](#input\_instance\_type) | The type of instance to start | `string` | `null` | no |
| <a name="input_kernel_id"></a> [kernel\_id](#input\_kernel\_id) | The kernel ID | `string` | `null` | no |
| <a name="input_key_name"></a> [key\_name](#input\_key\_name) | Key name of the Key Pair to use for the instance. | `string` | `null` | no |
| <a name="input_launch_from_launch_template"></a> [launch\_from\_launch\_template](#input\_launch\_from\_launch\_template) | Flag to decide launch from launch template or not | `bool` | `true` | no |
| <a name="input_launch_template"></a> [launch\_template](#input\_launch\_template) | Specifies a Launch Template to configure the instance. Parameters configured on this resource will override the corresponding parameters in the Launch Template | <pre>object({<br>    id      = optional(string)<br>    name    = optional(string)<br>    version = optional(string)<br>  })</pre> | `null` | no |
| <a name="input_launch_template_default_version"></a> [launch\_template\_default\_version](#input\_launch\_template\_default\_version) | Default version of the launch template | `string` | `null` | no |
| <a name="input_launch_template_description"></a> [launch\_template\_description](#input\_launch\_template\_description) | Description of launch template | `string` | `null` | no |
| <a name="input_launch_template_tags"></a> [launch\_template\_tags](#input\_launch\_template\_tags) | A map of additional tags to add to the tag\_specifications of launch template created | `map(string)` | `{}` | no |
| <a name="input_launch_template_version"></a> [launch\_template\_version](#input\_launch\_template\_version) | Launch template version | `string` | `"$Latest"` | no |
| <a name="input_launch_template_vpc_security_group_ids"></a> [launch\_template\_vpc\_security\_group\_ids](#input\_launch\_template\_vpc\_security\_group\_ids) | VPC security group ids lauch template | `list(string)` | `[]` | no |
| <a name="input_license_specifications"></a> [license\_specifications](#input\_license\_specifications) | A list of license specifications to associate with | `map(string)` | `null` | no |
| <a name="input_maintenance_options"></a> [maintenance\_options](#input\_maintenance\_options) | Maintenace options | `map(string)` | `null` | no |
| <a name="input_master_prefix"></a> [master\_prefix](#input\_master\_prefix) | To specify a key prefix for aws resource | `string` | `"dso"` | no |
| <a name="input_metadata_options"></a> [metadata\_options](#input\_metadata\_options) | Customize the metadata options of the instance | `map(string)` | `{}` | no |
| <a name="input_monitoring"></a> [monitoring](#input\_monitoring) | If true, the launched EC2 instance will have detailed monitoring enabled | `bool` | `false` | no |
| <a name="input_network_interfaces"></a> [network\_interfaces](#input\_network\_interfaces) | Customize network interfaces to be attached at instance boot time | `list(any)` | `[]` | no |
| <a name="input_placement"></a> [placement](#input\_placement) | The placement of the instance | `map(string)` | `null` | no |
| <a name="input_placement_group"></a> [placement\_group](#input\_placement\_group) | The Placement Group to start the instance in | `string` | `null` | no |
| <a name="input_private_dns_name_options"></a> [private\_dns\_name\_options](#input\_private\_dns\_name\_options) | Private DNS name options | `map(string)` | `null` | no |
| <a name="input_private_ip"></a> [private\_ip](#input\_private\_ip) | Private IP address to associate with the instance in the VPC | `list(string)` | `[]` | no |
| <a name="input_ram_disk_id"></a> [ram\_disk\_id](#input\_ram\_disk\_id) | The ID of the ram disk | `string` | `null` | no |
| <a name="input_record_name"></a> [record\_name](#input\_record\_name) | Name of the A record to create | `string` | `null` | no |
| <a name="input_root_block_device_mappings"></a> [root\_block\_device\_mappings](#input\_root\_block\_device\_mappings) | Customize details about the root block device of the instance. See Block Devices below for details | `list(map(string))` | `[]` | no |
| <a name="input_security_group_name"></a> [security\_group\_name](#input\_security\_group\_name) | Name of the security group. | `string` | `null` | no |
| <a name="input_security_groups"></a> [security\_groups](#input\_security\_groups) | The `security_groups` variable is a map of maps, where each map represents an AWS Security Group.<br>  The key of each entry acts as the Security Group name.<br>  List of available attributes of each Security Group entry:<br>  - `rules`: A list of objects representing a Security Group rule. The key of each entry acts as the name of the rule and<br>      needs to be unique across all rules in the Security Group.<br>      List of attributes available to define a Security Group rule:<br>      - `description`: Security Group description.<br>      - `type`: Specifies if rule will be evaluated on ingress (inbound) or egress (outbound) traffic.<br>      - `cidr_blocks`: List of CIDR blocks - for ingress, determines the traffic that can reach your instance. For egress<br>      Determines the traffic that can leave your instance, and where it can go. | <pre>map(object({<br>    name = optional(string)<br>    rules = map(object({<br>      from_port   = string<br>      to_port     = string<br>      protocol    = string<br>      type        = string<br>      cidr_blocks = optional(list(string), null)<br>      description = optional(string)<br>      self        = optional(string)<br>    }))<br>  }))</pre> | `null` | no |
| <a name="input_subnet_by_tag"></a> [subnet\_by\_tag](#input\_subnet\_by\_tag) | Tag Name of subnet to get list of subnets. | `string` | `null` | no |
| <a name="input_subnet_ids"></a> [subnet\_ids](#input\_subnet\_ids) | A list of subnets to assign to EC2. e.g. ['subnet-1a2b3c4d','subnet-1a2b3c4e','subnet-1a2b3c4f'] | `list(string)` | `[]` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of tags to add to all resources. | `map(string)` | `{}` | no |
| <a name="input_template_instance_type"></a> [template\_instance\_type](#input\_template\_instance\_type) | The type of instance to start | `string` | `null` | no |
| <a name="input_template_key_name"></a> [template\_key\_name](#input\_template\_key\_name) | Key name of the Key Pair to use for the instance. | `string` | `null` | no |
| <a name="input_template_network_interfaces"></a> [template\_network\_interfaces](#input\_template\_network\_interfaces) | Customize network interfaces to be attached at instance boot time | `list(any)` | `[]` | no |
| <a name="input_template_security_group_names"></a> [template\_security\_group\_names](#input\_template\_security\_group\_names) | Name of security group attached to lauch template | `list(string)` | `null` | no |
| <a name="input_timeouts"></a> [timeouts](#input\_timeouts) | Define maximum timeout for creating, updating, and deleting EC2 instance resources | <pre>object({<br>    create = optional(string, "10m")<br>    update = optional(string, "10m")<br>    delete = optional(string, "10m")<br>  })</pre> | `{}` | no |
| <a name="input_update_launch_template_default_version"></a> [update\_launch\_template\_default\_version](#input\_update\_launch\_template\_default\_version) | Whether to update the launch templates default version on each update. Conflicts with `launch_template_default_version` | `bool` | `true` | no |
| <a name="input_user_data"></a> [user\_data](#input\_user\_data) | Can be used instead of `user_data` to pass base64-encoded binary data directly. Use this instead of `user_data` whenever the value is not a valid UTF-8 string. For example, gzip-encoded user data must be base64-encoded and passed via this argument to avoid corruption | `string` | `null` | no |
| <a name="input_user_data_base64"></a> [user\_data\_base64](#input\_user\_data\_base64) | Can be used instead of `user_data` to pass base64-encoded binary data directly. Use this instead of `user_data` whenever the value is not a valid UTF-8 string. For example, gzip-encoded user data must be base64-encoded and passed via this argument to avoid corruption | `string` | `null` | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | The VPC ID where Security Group will be created. | `string` | `null` | no |
| <a name="input_vpc_security_group_ids"></a> [vpc\_security\_group\_ids](#input\_vpc\_security\_group\_ids) | Additional security group IDs to apply to the cluster, in addition to the provisioned default security group with ingress traffic from existing CIDR blocks and existing security groups | `list(string)` | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_iam_instance_profile_id"></a> [iam\_instance\_profile\_id](#output\_iam\_instance\_profile\_id) | Instance profile's ID |
| <a name="output_iam_role_arn"></a> [iam\_role\_arn](#output\_iam\_role\_arn) | The Amazon Resource Name (ARN) specifying the IAM role |
| <a name="output_iam_role_name"></a> [iam\_role\_name](#output\_iam\_role\_name) | The name of the IAM role |
| <a name="output_instance_dns"></a> [instance\_dns](#output\_instance\_dns) | List DNS name of instance assigned to the route 53. |
| <a name="output_instance_id"></a> [instance\_id](#output\_instance\_id) | List IDs of instances |
| <a name="output_instance_subnet_id"></a> [instance\_subnet\_id](#output\_instance\_subnet\_id) | List VPC subnets Ids of instances |
| <a name="output_private_ip"></a> [private\_ip](#output\_private\_ip) | List of private IP addresses assigned to the instances |
| <a name="output_public_ip"></a> [public\_ip](#output\_public\_ip) | List of public IP addresses assigned to the instances, if applicable |
| <a name="output_security_group_id"></a> [security\_group\_id](#output\_security\_group\_id) | ID of the security group |
