resource "mongodbatlas_privatelink_endpoint" "endpoint" {
  project_id    = var.project_id
  provider_name = "AWS"
  region        = var.region
}

resource "aws_security_group" "endpoint" {
  name        = "${var.component}-${var.deployment_identifier}-${mongodbatlas_privatelink_endpoint.endpoint.private_link_id}"
  description = "VPC endpoint security group for ${mongodbatlas_privatelink_endpoint.endpoint.endpoint_service_name}"
  vpc_id      = var.vpc_id

  tags = local.labels
}

resource "aws_security_group_rule" "ingress" {
  type = "ingress"

  security_group_id = aws_security_group.endpoint.id

  protocol  = "-1"
  from_port = 0
  to_port   = 0

  cidr_blocks = var.allow_cidrs
}

resource "aws_vpc_endpoint" "service" {
  vpc_id             = var.vpc_id
  service_name       = mongodbatlas_privatelink_endpoint.endpoint.endpoint_service_name
  vpc_endpoint_type  = "Interface"
  subnet_ids         = var.subnet_ids
  security_group_ids = [aws_security_group.endpoint.id]
}

resource "mongodbatlas_privatelink_endpoint_service" "service" {
  project_id          = mongodbatlas_privatelink_endpoint.endpoint.project_id
  private_link_id     = mongodbatlas_privatelink_endpoint.endpoint.private_link_id
  endpoint_service_id = aws_vpc_endpoint.service.id
  provider_name       = "AWS"
}
