variable "region" {}

variable "component" {}
variable "deployment_identifier" {}

variable "allow_cidrs" {
  type = list(string)
}

