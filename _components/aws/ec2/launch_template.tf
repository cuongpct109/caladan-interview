resource "aws_launch_template" "this" {
  count       = local.create && var.launch_template == null && var.launch_from_launch_template ? 1 : 0
  name        = format("%s-%s", var.master_prefix, var.launch_template_name)
  description = var.launch_template_description

  dynamic "block_device_mappings" {
    for_each = var.ebs_block_device_mappings
    content {
      device_name  = block_device_mappings.value.device_name
      no_device    = lookup(block_device_mappings.value, "no_device", null)
      virtual_name = lookup(block_device_mappings.value, "virtual_name", null)

      dynamic "ebs" {
        for_each = flatten([lookup(block_device_mappings.value, "ebs", [])])
        content {
          delete_on_termination = lookup(ebs.value, "delete_on_termination", null)
          encrypted             = lookup(ebs.value, "encrypted", null)
          kms_key_id            = lookup(ebs.value, "kms_key_id", null)
          iops                  = lookup(ebs.value, "iops", null)
          throughput            = lookup(ebs.value, "throughput", null)
          snapshot_id           = lookup(ebs.value, "snapshot_id", null)
          volume_size           = lookup(ebs.value, "volume_size", null)
          volume_type           = lookup(ebs.value, "volume_type", null)
        }
      }
    }
  }

  dynamic "capacity_reservation_specification" {
    for_each = var.capacity_reservation_specification != null ? [var.capacity_reservation_specification] : []
    content {
      capacity_reservation_preference = lookup(capacity_reservation_specification.value, "capacity_reservation_preference", null)

      dynamic "capacity_reservation_target" {
        for_each = try([capacity_reservation_specification.value.capacity_reservation_target], [])
        content {
          capacity_reservation_id                 = lookup(capacity_reservation_target.value, "capacity_reservation_id", null)
          capacity_reservation_resource_group_arn = lookup(capacity_reservation_target.value, "capacity_reservation_resource_group_arn", null)
        }
      }
    }
  }

  dynamic "cpu_options" {
    for_each = var.cpu_options != null ? [var.cpu_options] : []
    content {
      amd_sev_snp      = cpu_options.value.amd_sev_snp
      core_count       = cpu_options.value.core_count
      threads_per_core = cpu_options.value.threads_per_core
    }
  }

  dynamic "credit_specification" {
    for_each = var.credit_specification != null ? [var.credit_specification] : []
    content {
      cpu_credits = credit_specification.value.cpu_credits
    }
  }

  default_version         = var.launch_template_default_version
  disable_api_termination = var.disable_api_termination
  ebs_optimized           = var.ebs_optimized

  dynamic "elastic_gpu_specifications" {
    for_each = var.elastic_gpu_specifications != null ? [var.elastic_gpu_specifications] : []
    content {
      type = elastic_gpu_specifications.value.type
    }
  }

  dynamic "elastic_inference_accelerator" {
    for_each = var.elastic_inference_accelerator != null ? [var.elastic_inference_accelerator] : []
    content {
      type = elastic_inference_accelerator.value.type
    }
  }

  dynamic "enclave_options" {
    for_each = var.enclave_options != null ? [var.enclave_options] : []
    content {
      enabled = enclave_options.value.enabled
    }
  }

  dynamic "hibernation_options" {
    for_each = var.hibernation_options != null ? [var.hibernation_options] : []
    content {
      configured = hibernation_options.value.configured
    }
  }

  dynamic "iam_instance_profile" {
    for_each = var.iam_instance_profile != null ? [var.iam_instance_profile] : []
    content {
      name = lookup(var.iam_instance_profile, "name", null)
      arn  = lookup(var.iam_instance_profile, "arn", null)
    }
  }

  image_id                             = var.image_id
  instance_initiated_shutdown_behavior = var.instance_initiated_shutdown_behavior

  dynamic "instance_market_options" {
    for_each = var.instance_market_options != null ? [var.instance_market_options] : []
    content {
      market_type = instance_market_options.value.market_type

      dynamic "spot_options" {
        for_each = lookup(instance_market_options.value, "spot_options", null) != null ? [instance_market_options.value.spot_options] : []
        content {
          block_duration_minutes         = lookup(spot_options.value, "block_duration_minutes", null)
          instance_interruption_behavior = lookup(spot_options.value, "instance_interruption_behavior", null)
          max_price                      = lookup(spot_options.value, "max_price", null)
          spot_instance_type             = lookup(spot_options.value, "spot_instance_type", null)
          valid_until                    = lookup(spot_options.value, "valid_until", null)
        }
      }
    }
  }

  dynamic "instance_requirements" {
    for_each = var.instance_requirements != null ? [var.instance_requirements] : []
    content {
      allowed_instance_types = try(var.instance_requirements.allowed_instance_types)
      bare_metal             = try(var.instance_requirements.bare_metal)

      dynamic "accelerator_count" {
        for_each = lookup(instance_requirements.value, "accelerator_count", null) != null ? [instance_requirements.value.accelerator_count] : []
        content {
          min = lookup(accelerator_count.value, "min", null)
          max = lookup(accelerator_count.value, "max", null)
        }
      }
      accelerator_manufacturers = try(var.instance_requirements.accelerator_manufacturers, null)
      accelerator_names         = try(var.instance_requirements.accelerator_names, null)

      dynamic "accelerator_total_memory_mib" {
        for_each = lookup(instance_requirements.value, "accelerator_total_memory_mib", null) != null ? [instance_requirements.value.accelerator_total_memory_mib] : []
        content {
          min = lookup(accelerator_total_memory_mib.value, "min", null)
          max = lookup(accelerator_total_memory_mib.value, "max", null)
        }
      }

      dynamic "baseline_ebs_bandwidth_mbps" {
        for_each = lookup(instance_requirements.value, "baseline_ebs_bandwidth_mbps", null) != null ? [instance_requirements.value.baseline_ebs_bandwidth_mbps] : []
        content {
          min = lookup(baseline_ebs_bandwidth_mbps.value, "min", null)
          max = lookup(baseline_ebs_bandwidth_mbps.value, "max", null)
        }
      }

      burstable_performance   = try(var.instance_requirements.burstable_performance, null)
      cpu_manufacturers       = try(var.instance_requirements.cpu_manufacturers, null)
      excluded_instance_types = try(var.instance_requirements.excluded_instance_types, null)
      instance_generations    = try(var.instance_requirements.instance_generations, null)
      local_storage           = try(var.instance_requirements.local_storage, null)
      local_storage_types     = try(var.instance_requirements.local_storage_types, null)

      dynamic "memory_gib_per_vcpu" {
        for_each = lookup(instance_requirements.value, "memory_gib_per_vcpu", null) != null ? [instance_requirements.value.memory_gib_per_vcpu] : []
        content {
          min = lookup(memory_gib_per_vcp.value, "min", null)
          max = lookup(memory_gib_per_vcp.value, "max", null)
        }
      }

      dynamic "memory_mib" {
        for_each = lookup(instance_requirements.value, "memory_mib", null) != null ? [instance_requirements.value.memory_mib] : []
        content {
          min = lookup(memory_mib.value, "min", null)
          max = lookup(memory_mib.value, "max", null)
        }
      }

      dynamic "network_bandwidth_gbps" {
        for_each = lookup(instance_requirements.value, "network_bandwidth_gbps", null) != null ? [instance_requirements.value.network_bandwidth_gbps] : []
        content {
          min = lookup(network_bandwidth_gbps.value, "min", null)
          max = lookup(network_bandwidth_gbps.value, "max", null)
        }
      }

      dynamic "network_interface_count" {
        for_each = lookup(instance_requirements.value, "network_interface_count", null) != null ? [instance_requirements.value.network_interface_count] : []
        content {
          min = lookup(network_interface_count.value, "min", null)
          max = lookup(network_interface_count.value, "max", null)
        }
      }

      on_demand_max_price_percentage_over_lowest_price = try(var.instance_requirements.on_demand_max_price_percentage_over_lowest_price, null)
      require_hibernate_support                        = try(var.instance_requirements.require_hibernate_support, null)
      spot_max_price_percentage_over_lowest_price      = try(var.instance_requirements.spot_max_price_percentage_over_lowest_price, null)

      dynamic "total_local_storage_gb" {
        for_each = lookup(instance_requirements.value, "total_local_storage_gb", null) != null ? [instance_requirements.value.total_local_storage_gb] : []
        content {
          min = lookup(total_local_storage_gb.value, "min", null)
          max = lookup(total_local_storage_gb.value, "max", null)
        }
      }

      dynamic "vcpu_count" {
        for_each = lookup(instance_requirements.value, "vcpu_count", null) != null ? [instance_requirements.value.vcpu_count] : []
        content {
          min = lookup(vcpu_count.value, "min", null)
          max = lookup(vcpu_count.value, "max", null)
        }
      }

    }
  }

  instance_type = var.template_instance_type # This conflict with instance_types in instance_requirements
  kernel_id     = var.kernel_id
  key_name      = var.template_key_name

  dynamic "license_specification" {
    for_each = var.license_specifications != null ? [var.license_specifications] : []
    content {
      license_configuration_arn = license_specifications.value.license_configuration_arn
    }
  }

  dynamic "maintenance_options" {
    for_each = var.maintenance_options != null ? [var.maintenance_options] : []
    content {
      auto_recovery = maintenance_options.value.auto_recovery
    }
  }


  dynamic "metadata_options" {
    for_each = var.metadata_options != null ? [var.metadata_options] : []
    content {
      http_endpoint               = lookup(metadata_options.value, "http_endpoint", null)
      http_tokens                 = lookup(metadata_options.value, "http_tokens", null)
      http_put_response_hop_limit = lookup(metadata_options.value, "http_put_response_hop_limit", null)
      http_protocol_ipv6          = lookup(metadata_options.value, "http_protocol_ipv6", null)
      instance_metadata_tags      = lookup(metadata_options.value, "instance_metadata_tags", null)
    }
  }

  dynamic "monitoring" {
    for_each = var.monitoring != null ? [1] : []
    content {
      enabled = var.monitoring
    }
  }

  dynamic "network_interfaces" {
    for_each = var.template_network_interfaces
    content {
      associate_carrier_ip_address = lookup(network_interfaces.value, "associate_carrier_ip_address", null)
      associate_public_ip_address  = lookup(network_interfaces.value, "associate_public_ip_address", null)
      delete_on_termination        = lookup(network_interfaces.value, "delete_on_termination", null)
      description                  = lookup(network_interfaces.value, "description", null)
      device_index                 = lookup(network_interfaces.value, "device_index", null)
      interface_type               = lookup(network_interfaces.value, "interface_type", null)
      ipv4_prefix_count            = lookup(network_interfaces.value, "ipv4_prefix_count", null)
      ipv4_prefixes                = lookup(network_interfaces.value, "ipv4_prefixes", null)
      ipv4_addresses               = try(network_interfaces.value.ipv4_addresses, [])
      ipv4_address_count           = lookup(network_interfaces.value, "ipv4_address_count", null)
      ipv6_prefix_count            = lookup(network_interfaces.value, "ipv6_prefix_count", null)
      ipv6_prefixes                = lookup(network_interfaces.value, "ipv6_prefixes", null)
      ipv6_addresses               = try(network_interfaces.value.ipv6_addresses, [])
      ipv6_address_count           = lookup(network_interfaces.value, "ipv6_address_count", null)
      network_interface_id         = lookup(network_interfaces.value, "network_interface_id", null)
      network_card_index           = lookup(network_interfaces.value, "network_card_index", null)
      private_ip_address           = lookup(network_interfaces.value, "private_ip_address", null)
      security_groups              = lookup(network_interfaces.value, "security_groups", null)
      subnet_id                    = lookup(network_interfaces.value, "subnet_id", null)
    }
  }

  dynamic "placement" {
    for_each = var.placement != null ? [var.placement] : []
    content {
      affinity          = lookup(placement.value, "affinity", null)
      availability_zone = lookup(placement.value, "availability_zone", null)
      group_name        = lookup(placement.value, "group_name", null)
      host_id           = lookup(placement.value, "host_id", null)
      spread_domain     = lookup(placement.value, "spread_domain", null)
      tenancy           = lookup(placement.value, "tenancy", null)
      partition_number  = lookup(placement.value, "partition_number", null)
    }
  }

  dynamic "private_dns_name_options" {
    for_each = var.private_dns_name_options != null ? [var.private_dns_name_options] : []
    content {
      enable_resource_name_dns_aaaa_record = lookup(private_dns_name_options.value, "enable_resource_name_dns_aaaa_record", null)
      enable_resource_name_dns_a_record    = lookup(private_dns_name_options.value, "enable_resource_name_dns_a_record", null)
      hostname_type                        = lookup(private_dns_name_options.value, "hostname_type", null)
    }
  }

  ram_disk_id          = var.ram_disk_id
  security_group_names = var.template_security_group_names # conflict with vpc_security_group_ids

  dynamic "tag_specifications" {
    for_each = toset(["instance", "volume", "network-interface"])
    content {
      resource_type = tag_specifications.key
      tags          = var.launch_template_tags
    }
  }

  update_default_version = var.update_launch_template_default_version
  user_data              = var.user_data
  vpc_security_group_ids = var.launch_template_vpc_security_group_ids

  lifecycle {
    create_before_destroy = true
  }

  tags = merge(
    var.additional_tags,
    var.tags
  )
}
