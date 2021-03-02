variable "tags" {
  type        = map(string)
  description = "Tags to add to created resources."
}

variable "name" {
  type        = string
  description = "Name of the Service"
}

variable "cluster_id" {
  type        = string
  description = "ID of the ECS cluster"
}

variable "subnets" {
  type        = list(string)
  description = "Subnets"
}

variable "api_target_group_arn" {
  type        = string
  description = "Load balancer API target group arn"
}

variable "api_alb_sg" {
  type        = string
  description = "Load balancer SG for ingress"
}

variable "vpc_id" {
  type        = string
  description = "VPC ID"
}

variable "backend_container_image" {
  type        = string
  description = "Backend container image"
}

variable "backend_container_port" {
  type        = number
  description = "Backend container port"
}

variable "size" {
  type        = number
  description = "Service size"
}
