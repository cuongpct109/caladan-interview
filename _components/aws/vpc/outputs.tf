output "default_vpc_id" {
  value = data.aws_vpc.default.id
}

output "default_vpc_cidr" {
  value = data.aws_vpc.default.cidr_block
}

output "default_subnet_ids" {
  value = data.aws_subnets.default.ids
}