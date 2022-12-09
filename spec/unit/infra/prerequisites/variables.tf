variable "component" {}
variable "deployment_identifier" {}

variable "region" {}
variable "availability_zones" {
  type = list(string)
}
variable "vpc_cidr" {}

variable "organization_id" {}
