terraform {
  required_version = "~> 0.12.1"
}

provider "aws" {
  region = "eu-west-1"
}

module "dns" {
  source = "../"
  name   = "arghul.com"

  records = [
    { name = "www", type = "A", ttl = "10", value = "10.0.0.1" },
    { name = "a", type = "A", ttl = "10", value = "10.0.0.10", weight = 10 },
    { name = "a", type = "A", ttl = "10", value = "10.0.0.11", weight = 90 },
    { name = "", type = "MX", value = "10 10.0.0.3" }
  ]

}

output "name" {
  value = module.dns.name
}

output "zone_id" {
  value = module.dns.zone_id
}

output "name_servers" {
  value = module.dns.name_servers
}
