variable "prefix" {
  type        = string
  description = "Default Prefix of Resource Name"
}
variable "root_domain" {
  type        = string
  description = "RootDomain"
}
variable "alb_dns_name" {
  type        = string
  description = "DNS Name For ALB"
}
variable "alb_zone_id" {
  type        = string
  description = "ALB Zone ID"
}
variable "acm_main_domain_valid_options" {
  type        = set(any)
  description = "RootDomain ACM Valid Required Records"
}
variable "tags" {
  type = object({
    Environment = string
    Project     = string
    Terraform   = string
  })
}
