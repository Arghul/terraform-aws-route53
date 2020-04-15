locals {
  name = module.label.name
  default_ttl = 5

  records_simple = flatten([
    for record in var.records: [
    {
      name = record.name
      ttl = lookup(record, "ttl", local.default_ttl)
      type = lookup(record, "type", "A")
      value = record.value
    }] if lookup(record, "mvarp", false) == false && lookup(record, "weight", false ) == false
  ])

  records_mvarp = flatten([
  for record in var.records: [
    {
      name = record.name
      ttl = lookup(record, "ttl", local.default_ttl)
      type = lookup(record, "type", "A")
      value = record.value
    }] if lookup(record, "mvarp", false) == true
  ])

  records_wrp = flatten([
  for record in var.records: [
    {
      name = record.name
      ttl = lookup(record, "ttl", local.default_ttl)
      type = lookup(record, "type", "A")
      value = record.value
      weight = record.weight
    }] if lookup(record, "weight", false) != false
  ])
}

module "label" {
  source      = "git::https://github.com/cloudposse/terraform-null-label.git?ref=master"
  namespace   = var.namespace
  stage       = var.stage
  environment = var.environment
  name        = var.name
  attributes  = var.attributes
  delimiter   = var.delimiter
  tags        = var.tags
  regex_replace_chars = "/[^a-zA-Z0-9-.]/"
}

resource "aws_route53_zone" "private" {
  count = var.enable && var.type == "private" ? 1 : 0

  name          = local.name
  comment       = var.comment
  force_destroy = var.force_destroy
  tags          = module.label.tags

  vpc {
    vpc_id = var.vpc_id
  }
}

resource "aws_route53_zone" "public" {
  count = var.enable && var.type == "public" ? 1 : 0

  name              = local.name
  delegation_set_id = var.delegation_set_id
  comment           = var.comment
  force_destroy     = var.force_destroy
  tags              = module.label.tags
}

# simple routing policy
resource "aws_route53_record" "simple" {
  count                            = var.enable && length(local.records_simple) > 0 ? length(local.records_simple) : 0
  zone_id                          = var.type == "private" ? aws_route53_zone.private.*.zone_id[0] : aws_route53_zone.public.*.zone_id[0]
  name                             = element(local.records_simple, count.index).name
  type                             = element(local.records_simple, count.index).type
  ttl                              = element(local.records_simple, count.index).ttl
  records                          = split(",",element(local.records_simple, count.index).value)
}

# multivalue answer routing policy
resource "aws_route53_record" "mvarp" {
  count                            = var.enable && length(local.records_mvarp) > 0 ? length(local.records_mvarp) : 0
  zone_id                          = var.type == "private" ? aws_route53_zone.private.*.zone_id[0] : aws_route53_zone.public.*.zone_id[0]
  name                             = element(local.records_mvarp, count.index).name
  type                             = element(local.records_mvarp, count.index).type
  ttl                              = element(local.records_mvarp, count.index).ttl
  records                          = split(",",element(local.records_mvarp, count.index).value)
  multivalue_answer_routing_policy = true
  set_identifier                   = format("${element(local.records_mvarp, count.index).name}-%s", count.index)
}

# weighted routing policy
resource "aws_route53_record" "wrp" {
  count                            = var.enable && length(local.records_wrp) > 0 ? length(local.records_wrp) : 0
  zone_id                          = var.type == "private" ? aws_route53_zone.private.*.zone_id[0] : aws_route53_zone.public.*.zone_id[0]
  name                             = element(local.records_wrp, count.index).name
  type                             = element(local.records_wrp, count.index).type
  ttl                              = element(local.records_wrp, count.index).ttl
  records                          = split(",",element(local.records_wrp, count.index).value)
  set_identifier                   = format("${element(local.records_wrp, count.index).name}-%s", count.index)
  weighted_routing_policy {
    weight = element(local.records_wrp, count.index).weight
  }
}
