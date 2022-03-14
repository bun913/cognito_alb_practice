variable "prefix" {
  type        = string
  description = "Default Prefix of Resource Name"
}

variable "root_domain" {
  type        = string
  description = ""
}

variable "acm_sub_arn" {
  type        = string
  description = "ACM ARN Of auth.ROOT_DOMAIN"
}

variable "tags" {
  type = object({
    Environment = string
    Project     = string
    Terraform   = string
  })
}
