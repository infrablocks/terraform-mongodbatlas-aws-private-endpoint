variable "component" {
  description = "The component this project will contain."
  type        = string
}
variable "deployment_identifier" {
  description = "An identifier for this instantiation."
  type        = string
}

variable "project_id" {
  type        = string
  description = "The ID of the project within which to create the cluster."
}
