variable "component" {
  description = "The component this project will contain."
  type        = string
}
variable "deployment_identifier" {
  description = "An identifier for this instantiation."
  type        = string
}

variable "region" {
  description = "The AWS region for which to create the private endpoint."
  type        = string
}
variable "vpc_id" {
  description = "The ID of the VPC for which to create the private endpoint"
}
variable "subnet_ids" {
  description = "The subnet IDs within the VPC for which to create the private endpoint."
  type        = list(string)
}

variable "project_id" {
  type        = string
  description = "The ID of the project within which to create the cluster."
}

variable "allow_cidrs" {
  type        = list(string)
  description = "The CIDRs from which the private endpoint should be accessible."
}

variable "tags" {
  description = "A map of tags to be applied to the security group."
  type        = map(string)
  default     = {}
}