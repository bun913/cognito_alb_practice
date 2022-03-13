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

  ecr_base_uri = local.ecr_base_uri
  region       = var.region

  tags = var.tags
}
