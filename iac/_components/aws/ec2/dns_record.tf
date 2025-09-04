resource "aws_route53_record" "ec2_instance_dns" {
  count           = var.create_ec2 && var.create_dns ? var.instance_count : 0
  zone_id         = var.dns_zone_id
  name            = format("%s-%s-%s", var.master_prefix, var.instance_name, count.index + 1)
  type            = "A"
  ttl             = var.dns_zone_ttl
  allow_overwrite = true
  depends_on = [
    aws_instance.ec2_instance
  ]
  records = [
    aws_instance.ec2_instance[count.index].private_ip
  ]
}
