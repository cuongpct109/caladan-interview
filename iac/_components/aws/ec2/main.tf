resource "aws_instance" "ec2_instance" {
  count                                = local.create ? var.instance_count : 0
  ami                                  = var.launch_from_launch_template ? null : var.image_id # Use launch template configurations if create from launch template
  iam_instance_profile                 = var.launch_from_launch_template ? null : local.iam_instance_profile_name
  instance_type                        = try(var.instance_type, var.template_instance_type)
  key_name                             = var.launch_from_launch_template ? var.template_key_name : var.key_name
  associate_public_ip_address          = var.launch_from_launch_template ? false : var.associate_public_ip_address
  private_ip                           = !var.launch_from_launch_template && length(var.private_ip) == var.instance_count ? var.private_ip[count.index] : null
  availability_zone                    = var.availability_zone
  subnet_id                            = length(var.subnet_ids) > 0 ? tolist(var.subnet_ids)[count.index] : tolist(data.aws_subnets.selected.ids)[count.index]
  user_data                            = var.launch_from_launch_template ? null : (var.user_data != null ? var.user_data : local.user_data)
  vpc_security_group_ids               = compact(concat(var.vpc_security_group_ids, [for k, v in aws_security_group.security_group : v.id]))
  disable_api_termination              = var.launch_from_launch_template ? null : var.disable_api_termination
  user_data_base64                     = var.launch_from_launch_template ? null : var.user_data_base64
  ebs_optimized                        = var.launch_from_launch_template ? null : var.ebs_optimized
  get_password_data                    = var.launch_from_launch_template ? null : var.get_password_data
  monitoring                           = var.launch_from_launch_template ? null : var.monitoring
  hibernation                          = var.launch_from_launch_template ? null : (var.hibernation_options != null ? var.hibernation_options.configured : null)
  instance_initiated_shutdown_behavior = var.launch_from_launch_template ? null : var.instance_initiated_shutdown_behavior
  placement_group                      = var.launch_from_launch_template ? null : var.placement_group

  tags = merge(
    var.additional_tags,
    {
      Name = format("%s-%s-%s", var.master_prefix, var.instance_name, count.index + 1)
    }
  )

  dynamic "cpu_options" {
    for_each = !var.launch_from_launch_template && var.launch_template == null && var.cpu_options != null ? [var.cpu_options] : []
    content {
      amd_sev_snp      = cpu_options.value.amd_sev_snp
      core_count       = cpu_options.value.core_count
      threads_per_core = cpu_options.value.threads_per_core
    }
  }

  dynamic "root_block_device" {
    for_each = var.root_block_device_mappings
    content {
      delete_on_termination = lookup(root_block_device.value, "delete_on_termination", null)
      encrypted             = lookup(root_block_device.value, "encrypted", null)
      iops                  = lookup(root_block_device.value, "iops", null)
      kms_key_id            = lookup(root_block_device.value, "kms_key_id", null)
      volume_size           = lookup(root_block_device.value, "volume_size", null)
      volume_type           = lookup(root_block_device.value, "volume_type", null)
      throughput            = lookup(root_block_device.value, "throughput", null)
      tags = merge(
        var.additional_tags,
        {
          Name = format("%s-%s-%s", var.master_prefix, var.instance_name, count.index + 1)
        }
      )
    }
  }

  dynamic "ebs_block_device" {
    for_each = !var.launch_from_launch_template && var.launch_template == null ? var.ebs_block_device_mappings : []
    content {
      delete_on_termination = lookup(ebs_block_device.value, "delete_on_termination", null)
      device_name           = ebs_block_device.value.device_name
      encrypted             = lookup(ebs_block_device.value, "encrypted", null)
      iops                  = lookup(ebs_block_device.value, "iops", null)
      kms_key_id            = lookup(ebs_block_device.value, "kms_key_id", null)
      snapshot_id           = lookup(ebs_block_device.value, "snapshot_id", null)
      volume_size           = lookup(ebs_block_device.value, "volume_size", null)
      volume_type           = lookup(ebs_block_device.value, "volume_type", null)
      throughput            = lookup(ebs_block_device.value, "throughput", null)
      tags = merge(
        var.additional_tags,
        {
          Name = format("%s-%s-%s-Volume-%s", var.master_prefix, var.instance_name, count.index + 1, ebs_block_device.key + 1)
        }
      )
    }
  }

  dynamic "ephemeral_block_device" {
    for_each = var.ephemeral_block_device
    content {
      device_name  = ephemeral_block_device.value.device_name
      no_device    = lookup(ephemeral_block_device.value, "no_device", null)
      virtual_name = lookup(ephemeral_block_device.value, "virtual_name", null)
    }
  }

  dynamic "metadata_options" {
    for_each = !var.launch_from_launch_template && var.launch_template == null && var.metadata_options != null ? [var.metadata_options] : []
    content {
      http_endpoint               = lookup(metadata_options.value, "http_endpoint", "enabled")
      http_tokens                 = lookup(metadata_options.value, "http_tokens", "optional")
      http_put_response_hop_limit = lookup(metadata_options.value, "http_put_response_hop_limit", "1")
      instance_metadata_tags      = lookup(metadata_options.value, "instance_metadata_tags", null)
    }
  }

  dynamic "network_interface" {
    for_each = var.network_interfaces

    content {
      device_index          = network_interface.value.device_index
      network_interface_id  = lookup(network_interface.value, "network_interface_id", null)
      delete_on_termination = lookup(network_interface.value, "delete_on_termination", false)
    }
  }

  dynamic "launch_template" {
    for_each = var.launch_from_launch_template ? [1] : []
    content {
      id      = var.launch_template == null ? aws_launch_template.this[0].id : var.launch_template.id
      name    = var.launch_template == null ? null : var.launch_template.name # Either name and value is specified, not both
      version = var.launch_template == null ? var.launch_template_version : var.launch_template.version
    }
  }

  dynamic "enclave_options" {
    for_each = !var.launch_from_launch_template && var.launch_template == null && var.enclave_options != null ? [var.enclave_options] : []
    content {
      enabled = enclave_options.value.enabled
    }
  }

  timeouts {
    create = var.timeouts.create
    update = var.timeouts.update
    delete = var.timeouts.delete
  }

}
