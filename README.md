# Terraform AWS Route53

Terraform module to create AWS Route53 zone and records


## Prerequisites
This module has a few dependencies:
* Terraform 0.12

## Examples
Create a zone *arghul.com* with 2 records
```hcl-terraform
module "dns" {
  source = "git::https://github.com/arghul/terraform-aws-route53.git?ref=master"
  name = "arghul.com"

  records = [
    { name = "www", type = "A", ttl = "10", value = "10.0.0.1" },
    { name = "", type = "MX", value = "10 10.0.0.3" }
  ]
}
```
Create a zone *arghul.com* and some records using *weight* attribute for weighted routing policy
```hcl-terraform
module "dns" {
  source = "git::https://github.com/arghul/terraform-aws-route53.git?ref=master"
  name = "arghul.com"

  records = [
    { name = "www", type = "A", ttl = "10", value = "10.0.0.1" },
    { name = "a", type = "A", ttl = "10", value = "10.0.0.10", weight = "10" },
    { name = "a", type = "A", ttl = "10", value = "10.0.0.11", weight = "90" },
    { name = "", type = "MX", value = "10 10.0.0.3" }
  ]
}
```
Create a zone *arghul.com* and some records using *mvarp* attribute for multi value routing policy
```hcl-terraform
module "dns" {
  source = "git::https://github.com/arghul/terraform-aws-route53.git?ref=master"
  name = "arghul.com"

  records = [
    { name = "www", type = "A", ttl = "10", value = "10.0.0.1" },
    { name = "a", type = "A", ttl = "10", value = "10.0.0.10", mvarp = true },
    { name = "a", type = "A", ttl = "10", value = "10.0.0.11", mvarp = true },
    { name = "", type = "MX", value = "10 10.0.0.3" }
  ]
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| attributes | Additional attributes | `list(string)` | `[]` | no |
| comment | A comment for the hosted zone. Defaults to 'Managed by Terraform'. | `string` | `""` | no |
| delegation\_set\_id | The ID of the reusable delegation set whose NS records you want to assign to the hosted zone. Conflicts with vpc as delegation sets can only be used for public zones. | `string` | `""` | no |
| delimiter | Label delimiter | `string` | `"-"` | no |
| enable | Whether to enable or disable module | `bool` | `true` | no |
| environment | Environment, e.g. 'prod', 'staging', 'dev', 'pre-prod', 'UAT' | `string` | `""` | no |
| force\_destroy | Whether to destroy all records (possibly managed outside of Terraform) in the zone when destroying the zone. | `bool` | `true` | no |
| name | Service name | `any` | n/a | yes |
| namespace | Service namespace (eg: api, web, ops) | `string` | `""` | no |
| records | name, ttl, value, weight, mvarp | `any` | n/a | yes |
| stage | Stage, e.g. 'prod', 'staging', 'dev', OR 'source', 'build', 'test', 'deploy', 'release' | `string` | `""` | no |
| tags | Service tags | `map(string)` | `{}` | no |
| type | Whether zone is private or public | `string` | `"public"` | no |
| vpc\_id | n/a | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| name | n/a |
| name\_servers | n/a |
| zone\_id | n/a |