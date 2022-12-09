module "project" {
  source  = "infrablocks/project/mongodbatlas"
  version = "1.2.0-rc.2"

  component = var.component
  deployment_identifier = var.deployment_identifier

  organization_id = var.organization_id
}

module "base_network" {
  source  = "infrablocks/base-networking/aws"
  version = "4.1.0-rc.5"

  vpc_cidr           = var.vpc_cidr
  region             = var.region
  availability_zones = var.availability_zones

  component             = var.component
  deployment_identifier = var.deployment_identifier

  include_route53_zone_association = "no"
  include_nat_gateways = "no"
}
