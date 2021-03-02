variable "aws_availability_zones" {
  type        = list(string)
  description = "List of availability zones"
}

variable "vpc_cidr" {
  type        = string
  description = "VPC CIDR block address"
}

variable "tags" {
  type        = map(string)
  description = "Tags to add to created resources."
}

variable "name" {
  type        = string
  description = "Name of the VPC"
}

variable "public_subnets" {
  type        = list(string)
  description = "Public subnets"
}

variable "private_subnets" {
  type        = list(string)
  description = "Private subnets"
}
