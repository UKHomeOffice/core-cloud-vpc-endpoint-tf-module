resource "aws_vpc_endpoint" "this" {
  vpc_id            = var.vpc_id
  service_name      = var.service_name
  vpc_endpoint_type = "Interface"

  security_group_ids  = var.security_group_ids
  subnet_ids          = var.subnet_ids
  private_dns_enabled = var.managed_private_dns_enabled

  tags = merge(
    var.tags,
    {
      "Name" = var.vpc_endpoint_name
    }
  )
}

resource "aws_route53_zone" "private" {
  count = !var.managed_private_dns_enabled && var.custom_private_r53_zone != "" ? 1 : 0

  name = var.custom_private_r53_zone

  dynamic "vpc" {
    for_each = toset(concat([var.vpc_id], var.custom_private_r53_associated_vpcs))
    content {
      vpc_id = vpc.key
    }
  }

  tags = merge(
    var.tags,
    {
      "vpce_name" = var.vpc_endpoint_name
      "vpce_id"   = aws_vpc_endpoint.this.id
    }
  )
}

resource "aws_route53_record" "this" {
  count   = !var.managed_private_dns_enabled && var.custom_private_r53_zone != "" ? 1 : 0
  zone_id = aws_route53_zone.private[0].zone_id
  name    = var.custom_private_r53_zone
  type    = "A"

  alias {
    name                   = "${aws_vpc_endpoint.this.dns_entry[0]["dns_name"]}."
    zone_id                = aws_vpc_endpoint.this.dns_entry[0].hosted_zone_id
    evaluate_target_health = true
  }
}
