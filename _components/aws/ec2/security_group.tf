############################################################
# Security Groups
############################################################
resource "aws_security_group" "security_group" {
  for_each = local.create_security_group ? var.security_groups : {}

  name   = format("%s-%s-%s-sg", var.master_prefix, local.security_group_name, each.key)
  vpc_id = var.vpc_id

  dynamic "ingress" {
    for_each = [
      for rule in each.value.rules :
      rule
      if rule.type == "ingress"
    ]

    content {
      from_port   = ingress.value.from_port
      to_port     = ingress.value.to_port
      protocol    = ingress.value.protocol
      cidr_blocks = ingress.value.cidr_blocks
      description = ingress.value.description
      self        = ingress.value.self
    }
  }

  dynamic "egress" {
    for_each = [
      for rule in each.value.rules :
      rule
      if rule.type == "egress"
    ]

    content {
      from_port   = egress.value.from_port
      to_port     = egress.value.to_port
      protocol    = egress.value.protocol
      cidr_blocks = egress.value.cidr_blocks
      description = egress.value.description
      self        = egress.value.self
    }
  }

  tags = merge(var.tags,
    {
      Name = format("%s-%s-%s-sg", var.master_prefix, local.security_group_name, each.key)
    }
  )

  lifecycle {
    create_before_destroy = true
  }
}
