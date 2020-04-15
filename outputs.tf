output "name" {
  value = var.type == "private" ? aws_route53_zone.private.*.name : aws_route53_zone.public.*.name
}

output "zone_id" {
  value = var.type == "private" ? aws_route53_zone.private.*.zone_id : aws_route53_zone.public.*.zone_id
}

output "name_servers" {
  value = var.type == "private" ? aws_route53_zone.private.*.name_servers : aws_route53_zone.public.*.name_servers
}

