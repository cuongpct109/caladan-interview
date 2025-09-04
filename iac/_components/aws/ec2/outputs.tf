output "instance_dns" {
  description = "List DNS name of instance assigned to the route 53."
  value       = try(aws_route53_record.ec2_instance_dns[0].name, "")
}

output "instance_id" {
  description = "List IDs of instances"
  value       = { for k, v in aws_instance.ec2_instance : k => v.id }
}

output "instance_subnet_id" {
  description = "List VPC subnets Ids of instances"
  value       = { for k, v in aws_instance.ec2_instance : k => v.subnet_id }
}

output "private_ip" {
  description = "List of private IP addresses assigned to the instances"
  value       = { for k, v in aws_instance.ec2_instance : k => v.private_ip }

}

output "public_ip" {
  description = "List of public IP addresses assigned to the instances, if applicable"
  value       = { for k, v in aws_instance.ec2_instance : k => v.public_ip }
}

output "security_group_id" {
  description = "ID of the security group"
  value       = { for k, v in aws_security_group.security_group : k => v.id }
}

################################################################################
# IAM Role / Instance Profile
################################################################################

output "iam_role_name" {
  description = "The name of the IAM role"
  value       = try(aws_iam_role.instance_profile[0].name, null)
}

output "iam_role_arn" {
  description = "The Amazon Resource Name (ARN) specifying the IAM role"
  value       = try(aws_iam_role.instance_profile[0].arn, null)
}

output "iam_instance_profile_id" {
  description = "Instance profile's ID"
  value       = try(aws_iam_instance_profile.instance_profile[0].id, null)
}
