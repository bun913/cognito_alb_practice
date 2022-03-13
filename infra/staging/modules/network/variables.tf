variable "prefix" {
  type        = string
  description = "Default Prefix of Resource Name"
}
variable "vpc_cidr" {
  type        = string
  description = "Main VPC CidrBlock"
}
variable "public_subnets" {
  type = list(object({
    name = string
    az   = string
    cidr = string
  }))
  description = "Public Subnets For ALB"
}
variable "private_subnets" {
  type = list(object({
    name = string
    az   = string
    cidr = string
  }))
  description = "Private Subnets For APP"
}
variable "tags" {
  type = object({
    Environment = string
    Project     = string
    Terraform   = string
  })
}
