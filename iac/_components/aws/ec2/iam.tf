################################################################################
# IAM Role / Instance Profile
################################################################################
resource "aws_iam_role" "instance_profile" {
  count = local.create && var.create_iam_instance_profile ? 1 : 0

  name        = local.internal_iam_instance_profile_name
  path        = var.iam_role_path
  description = var.iam_role_description

  assume_role_policy    = data.aws_iam_policy_document.assume_role_policy[0].json
  permissions_boundary  = var.iam_role_permissions_boundary
  force_detach_policies = true

  tags = var.iam_role_tags
}

resource "aws_iam_role_policy_attachment" "policy_attachment" {
  for_each = { for k, v in var.iam_role_policies : k => v if local.create && var.create_iam_instance_profile }

  policy_arn = each.value
  role       = aws_iam_role.instance_profile[0].name
}

resource "aws_iam_policy" "custom_policy" {
  count = local.create && var.create_iam_instance_profile && var.custom_policy != null ? 1 : 0

  name   = format("%s-%s-policy", var.master_prefix, var.instance_name)
  policy = var.custom_policy
}

resource "aws_iam_role_policy_attachment" "custom_policy_attachment" {
  count = local.create && var.create_iam_instance_profile && var.custom_policy != null ? 1 : 0

  policy_arn = aws_iam_policy.custom_policy[0].arn
  role       = aws_iam_role.instance_profile[0].name
}


resource "aws_iam_instance_profile" "instance_profile" {
  count = local.create && var.create_iam_instance_profile ? 1 : 0

  role = aws_iam_role.instance_profile[0].name

  name = local.internal_iam_instance_profile_name
  path = var.iam_role_path

  tags = var.iam_role_tags
}
