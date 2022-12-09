module "aws_private_endpoint" {
  source = "./../../"

  component             = var.component
  deployment_identifier = var.deployment_identifier

  region = var.region
  vpc_id = module.base_network.vpc_id
  subnet_ids = module.base_network.private_subnet_ids

  project_id = module.project.project_id

  allow_cidrs = var.allow_cidrs
}
