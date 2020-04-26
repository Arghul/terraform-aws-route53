variable "enable" {
  description = "Whether to enable or disable module"
  type        = bool
  default     = true
}

variable "name" {
  description = "Service name"
}

variable "namespace" {
  description = "Service namespace (eg: api, web, ops)"
  default     = ""
}

variable "stage" {
  description = "Stage, e.g. 'prod', 'staging', 'dev', OR 'source', 'build', 'test', 'deploy', 'release'"
  type        = string
  default     = ""
}

variable "environment" {
  description = "Environment, e.g. 'prod', 'staging', 'dev', 'pre-prod', 'UAT'"
  type        = string
  default     = ""
}

variable "attributes" {
  description = "Additional attributes"
  type        = list(string)
  default     = []
}

variable "delimiter" {
  description = "Label delimiter"
  type        = string
  default     = "-"
}

variable "tags" {
  description = "Service tags"
  type        = map(string)
  default     = {}
}

variable "vpc_id" {
  default = ""
}

variable "comment" {
  description = "A comment for the hosted zone. Defaults to 'Managed by Terraform'."
  type        = string
  default     = ""
}

variable "force_destroy" {
  description = "Whether to destroy all records (possibly managed outside of Terraform) in the zone when destroying the zone."
  type        = bool
  default     = true
}

variable "delegation_set_id" {
  type        = string
  default     = ""
  description = "The ID of the reusable delegation set whose NS records you want to assign to the hosted zone. Conflicts with vpc as delegation sets can only be used for public zones."
}

variable "type" {
  type        = string
  default     = "public"
  description = "Whether zone is private or public"
}

variable "zone" {
  type        = string
  description = "Zone name"
  default     = ""
}

variable "default_ttl" {
  type        = string
  description = "Default TTL"
  default     = 5
}

#
# name, ttl, value, weight, mvarp
#
variable "records" {
  type = any
}

