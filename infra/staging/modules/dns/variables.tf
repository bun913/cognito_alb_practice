variable "prefix" {
  type        = string
  description = "Default Prefix of Resource Name"
}
variable "root_domain" {
  type        = string
  description = "RootDomain"
}
variable "tags" {
  type = object({
    Environment = string
    Project     = string
    Terraform   = string
  })
}
