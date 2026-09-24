terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

module "network" {
  source = "./modules/network"


}

module "security" {
  source = "./modules/security"

  vpc_id = module.network.vpc_id

}

module "ecs" {
  source = "./modules/ecs"

  aws_region             = var.aws_region
  private_subnet_ids     = module.network.private_subnet_ids
  task_security_group_id = module.security.task_security_group_id
  target_group_arn       = module.alb.target_group_arn
}

module "alb" {
  source = "./modules/alb"

  vpc_id                = module.network.vpc_id
  public_subnet_ids     = module.network.public_subnet_ids
  alb_security_group_id = module.security.alb_security_group_id
}