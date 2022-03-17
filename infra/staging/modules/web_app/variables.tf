variable "prefix" {
  type        = string
  description = "Default Prefix of Resource Name"
}
variable "region" {
  type = string
}
variable "vpc_id" {
  type = string
}
variable "vpc_cidr" {
  type        = string
  description = "VPC Cidr"
}
variable "public_subnets" {
  type        = list(string)
  description = "PublicSubnetID List"
}
variable "private_subnets" {
  type        = list(string)
  description = "PrivateSubnetID List"
}
variable "private_route_table_id" {
  type        = string
  description = "PrivateSubnet RouteTable id"
}
variable "interface_services" {
  type        = list(string)
  description = "Service_names for interface vpc endpoint"
}

variable "gateway_services" {
  type        = list(string)
  description = "Service_names for gateway vpc endpoint"
}
variable "ecr_base_uri" {
  type        = string
  description = "ECR Repository Base URI"
}
variable "acm_arn" {
  type        = string
  description = "ACM ARN Of Root Domain"
}
variable "tags" {
  type = object({
    Environment = string
    Project     = string
    Terraform   = string
  })
}

variable "user_pool_arn" {
  type = string
}
variable "cognito_client_id" {
  type = string
}
variable "cognito_domain" {
  type = string
}
