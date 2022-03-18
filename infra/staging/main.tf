terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.2.0"
    }
  }
}

provider "aws" {
  region = "ap-northeast-1"
  /* shared_config_files      = ["./.aws/config"] */
  /* shared_credentials_files = ["./.aws/credentials"] */
  # profile = "hoge"
}

data "aws_caller_identity" "current" {}

locals {
  default_prefix = "${var.tags.Project}-${var.tags.Environment}"
  ecr_base_uri   = "${data.aws_caller_identity.current.account_id}.dkr.ecr.ap-northeast-1.amazonaws.com"
}

module "network" {
  source = "./modules/network/"

  prefix          = local.default_prefix
  vpc_cidr        = var.vpc_cidr
  public_subnets  = var.public_subnets
  private_subnets = var.private_subnets

  tags = var.tags
}

module "web_app" {
  source = "./modules/web_app/"

  prefix = local.default_prefix
  vpc_id = module.network.vpc_id

  public_subnets         = module.network.public_subnet_ids
  private_subnets        = module.network.private_subnet_ids
  private_route_table_id = module.network.private_route_table_id
  vpc_cidr               = var.vpc_cidr
  interface_services     = var.vpc_endpoint.interface
  gateway_services       = var.vpc_endpoint.gateway
  acm_arn                = module.cert.acm_arn

  user_pool_arn     = module.auth.user_pool_arn
  cognito_client_id = module.auth.cognito_client_id
  cognito_domain    = module.auth.cognito_domain

  ecr_base_uri = local.ecr_base_uri
  region       = var.region

  tags = var.tags
}

module "dns" {
  source = "./modules/dns/"

  prefix                        = local.default_prefix
  root_domain                   = var.root_domain
  host_zone_id                  = var.host_zone_id
  alb_dns_name                  = module.web_app.alb_dns_name
  alb_zone_id                   = module.web_app.alb_zone_id
  acm_main_domain_valid_options = module.cert.acm_main_domain_valid_options
  acm_sub_domain_valid_options  = module.cert.acm_sub_domain_valid_options

  tags = var.tags
}

module "cert" {
  source = "./modules/cert/"

  root_domain = var.root_domain
}
module "auth" {
  source = "./modules/auth/"

  prefix      = local.default_prefix
  root_domain = var.root_domain
  acm_sub_arn = module.cert.acm_sub_arn

  tags = var.tags
}
