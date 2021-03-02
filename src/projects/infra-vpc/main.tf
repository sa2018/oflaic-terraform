resource "aws_eip" "nat" {
  count = local.is_production ? length(var.aws_availability_zones) : 1
  vpc   = true
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "2.70.0"

  name = var.name
  tags = var.tags
  cidr = var.vpc_cidr
  azs  = var.aws_availability_zones

  enable_dns_support   = true
  enable_dns_hostnames = true
  enable_nat_gateway   = true

  single_nat_gateway     = local.is_production ? false : true
  one_nat_gateway_per_az = local.is_production ? true : false

  map_public_ip_on_launch = true
  reuse_nat_ips           = true
  external_nat_ip_ids     = aws_eip.nat.*.id

  public_subnets  = var.public_subnets
  private_subnets = var.private_subnets

}
