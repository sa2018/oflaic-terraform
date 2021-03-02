terraform {
  required_version = ">= 0.13.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.10.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

module "vpc" {
  source                 = "./projects/infra-vpc/"
  tags                   = local.default_tags
  name                   = local.namespace
  aws_availability_zones = var.aws_availability_zones
  vpc_cidr               = var.vpc_cidr
  public_subnets         = var.public_subnets
  private_subnets        = var.private_subnets
}

module "ecs" {
  source = "./projects/infra-ecs/"
  name   = local.namespace
  tags   = local.default_tags
}


module "loadbalancer" {
  source                 = "./projects/infra-alb/"
  name                   = local.namespace
  tags                   = local.default_tags
  subnets                = module.vpc.public_subnets
  vpc_id                 = module.vpc.vpc_id
  backend_container_port = var.backend_container_port
}

module "app-backend" {
  source                  = "./projects/app-backend/"
  name                    = "${local.namespace}-backend"
  tags                    = local.default_tags
  cluster_id              = module.ecs.cluster_id
  subnets                 = module.vpc.private_subnets
  api_target_group_arn    = module.loadbalancer.api_target_group_arn
  api_alb_sg              = module.loadbalancer.alb_sg
  vpc_id                  = module.vpc.vpc_id
  backend_container_image = var.backend_container_image
  backend_container_port  = var.backend_container_port
  size                    = length(var.aws_availability_zones)
}
