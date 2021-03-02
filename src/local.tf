locals {

  default_tags = {
    Environment = var.environment
    Terraform   = "true"
    Project     = var.project
  }

  namespace = "${var.project}-${var.environment}"

}
