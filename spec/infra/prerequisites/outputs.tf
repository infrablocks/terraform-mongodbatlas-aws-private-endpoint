output "project_id" {
  value = module.project.project_id
}

output "vpc_id" {
  value = module.base_network.vpc_id
}

output "subnet_ids" {
  value = module.base_network.private_subnet_ids
}
