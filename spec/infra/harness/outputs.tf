output "private_link_id" {
  value = module.aws_private_endpoint.private_link_id
}

output "endpoint_service_name" {
  value = module.aws_private_endpoint.endpoint_service_name
}

output "interface_endpoints" {
  value = module.aws_private_endpoint.interface_endpoints
}

output "vpc_endpoint_id" {
  value = module.aws_private_endpoint.vpc_endpoint_id
}

output "interface_endpoint_id" {
  value = module.aws_private_endpoint.interface_endpoint_id
}

output "private_endpoint" {
  value = module.aws_private_endpoint.private_endpoint
}
