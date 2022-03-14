variable "region" {
  type    = string
  default = "ap-northeast-1"
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
variable "vpc_endpoint" {
  # TODO: 型を丁寧に書く
  type        = map(any)
  description = "vpc_endpoint_setting"
}
variable "root_domain" {
  type        = string
  description = "Domain For ALB"
}
variable "tags" {
  type = map(string)
  default = {
    "Project"     = "cognito-alb"
    "Environment" = "stg"
    "Terraform"   = "true"
  }
}
