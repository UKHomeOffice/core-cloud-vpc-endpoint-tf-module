output "vpce_endpoint_id" {
  value = aws_vpc_endpoint.this.id
}

output "vpce_endpoint_arn" {
  value = aws_vpc_endpoint.this.arn
}

output "vpce_endpoint_dns" {
  value = aws_vpc_endpoint.this.dns_entry
}

output "custom_r53_phz_id" {
  value = aws_route53_zone.private.*.id
}

output "custom_r53_phz_arn" {
  value = aws_route53_zone.private.*.arn
}
