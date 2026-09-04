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

}