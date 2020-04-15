# Terraform AWS Route53

Terraform module to create AWS Route53 zone and records


## Prerequisites
This module has a few dependencies:
* Terraform 0.12

## Examples
Create a zone *arghul.com* with 2 records
```hcl-terraform
module "dns" {
  source = "../"
  name = "arghul.com"

  records = [
    { name = "www", type = "A", ttl = "10", value = "10.0.0.1" },
    { name = "", type = "MX", value = "10 10.0.0.3" }
  ]
}
```
Create a zone *arghul.com* and some records using *weight* attribute for weighted policy routing
```hcl-terraform
module "dns" {
  source = "../"
  name = "arghul.com"

  records = [
    { name = "www", type = "A", ttl = "10", value = "10.0.0.1" },
    { name = "a", type = "A", ttl = "10", value = "10.0.0.10", weight = "10" },
    { name = "a", type = "A", ttl = "10", value = "10.0.0.11", weight = "90" },
    { name = "", type = "MX", value = "10 10.0.0.3" }
  ]
}
```
Create a zone *arghul.com* and some records using *mvarp* attribute for multi value policy routing
```hcl-terraform
module "dns" {
  source = "../"
  name = "arghul.com"

  records = [
    { name = "www", type = "A", ttl = "10", value = "10.0.0.1" },
    { name = "a", type = "A", ttl = "10", value = "10.0.0.10", mvarp = true },
    { name = "a", type = "A", ttl = "10", value = "10.0.0.11", mvarp = true },
    { name = "", type = "MX", value = "10 10.0.0.3" }
  ]
}
```
