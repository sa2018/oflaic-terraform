variable "aws_region" {
  type    = string
  default = "ap-southeast-1"
}

variable "aws_availability_zones" {
  type        = list(string)
  description = "List of availability zones"
  default = [
    "ap-southeast-1a",
    "ap-southeast-1b"
  ]
}

variable "vpc_cidr" {
  type        = string
  description = "VPC CIDR block address"
  default     = "10.0.0.0/16"
}

variable "project" {
  type        = string
  description = "Project name"
  default     = "app"
}

variable "environment" {
  type        = string
  description = "Environment"
  default     = "stg"
}

variable "public_subnets" {
  type        = list(string)
  description = "Public subnets"
  default = [
    "10.0.1.0/24",
    "10.0.2.0/24"
  ]
}

variable "private_subnets" {
  type        = list(string)
  description = "Private subnets"
  default = [
    "10.0.10.0/24",
    "10.0.11.0/24"
  ]
}

variable "backend_container_image" {
  type        = string
  description = "Backend container image"
  default     = "seartun/dummy-api"
}

variable "backend_container_port" {
  type        = number
  description = "Backend container port"
  default     = 3030
}
