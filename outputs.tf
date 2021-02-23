output "private_link_id" {
  value = mongodbatlas_privatelink_endpoint.endpoint.private_link_id
}

output "endpoint_service_name" {
  value = mongodbatlas_privatelink_endpoint.endpoint.endpoint_service_name
}

output "interface_endpoints" {
  value = mongodbatlas_privatelink_endpoint.endpoint.interface_endpoints
}

output "vpc_endpoint_id" {
  value = aws_vpc_endpoint.service.id
}

output "interface_endpoint_id" {
  value = mongodbatlas_privatelink_endpoint_service.service.interface_endpoint_id
}

output "private_endpoint" {
  value = {
    connection_name: mongodbatlas_privatelink_endpoint_service.service.private_endpoint_connection_name,
    ip_address: mongodbatlas_privatelink_endpoint_service.service.private_endpoint_ip_address,
    resource_id: mongodbatlas_privatelink_endpoint_service.service.private_endpoint_resource_id
  }
}
