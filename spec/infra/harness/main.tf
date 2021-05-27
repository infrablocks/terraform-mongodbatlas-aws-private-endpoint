data "terraform_remote_state" "prerequisites" {
  backend = "local"

  config = {
    path = "${path.module}/../../../../state/prerequisites.tfstate"
  }
}

module "aws_private_endpoint" {
  # This makes absolutely no sense. I think there's a bug in terraform.
  source = "./../../../../../../../"

  component             = var.component
  deployment_identifier = var.deployment_identifier

  region = var.region
  vpc_id = data.terraform_remote_state.prerequisites.outputs.vpc_id
  subnet_ids = data.terraform_remote_state.prerequisites.outputs.subnet_ids

  project_id = data.terraform_remote_state.prerequisites.outputs.project_id

  allow_cidrs = var.allow_cidrs
}
