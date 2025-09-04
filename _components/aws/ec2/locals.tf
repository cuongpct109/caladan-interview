locals {
  create                             = var.create_ec2
  create_security_group              = var.create_security_group && local.create ? true : false
  security_group_name                = var.security_group_name != null ? var.security_group_name : format("%s-ec2", var.instance_name)
  internal_iam_instance_profile_name = format("%s-%s-role", var.master_prefix, var.instance_name)
  iam_instance_profile_name          = var.create_iam_instance_profile && local.create && var.iam_instance_profile.name == null ? local.internal_iam_instance_profile_name : var.iam_instance_profile.name
  user_data = base64encode(templatefile(
    "${path.module}/templates/bootstrap.tpl",
    {
      bootstrap_options = var.bootstrap_options
  }))
}
