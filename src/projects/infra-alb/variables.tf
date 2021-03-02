variable "tags" {
  type        = map(string)
  description = "Tags to add to created resources."
}

variable "name" {
  type        = string
  description = "Name of the Load Balancer"
}

variable "subnets" {
  type        = list(string)
  description = "Subnets"
}

variable "vpc_id" {
  type        = string
  description = "VPC ID"
}

variable "backend_container_port" {
  type        = number
  description = "Backend container port"
}
