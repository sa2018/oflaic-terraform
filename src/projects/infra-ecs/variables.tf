
variable "tags" {
  type        = map(string)
  description = "Tags to add to created resources."
}

variable "name" {
  type        = string
  description = "Name of the ECS Cluster"
}
