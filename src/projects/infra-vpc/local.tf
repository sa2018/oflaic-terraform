locals {
  is_production = lookup(var.tags, "Environment", "stg") == "prod" ? true : false
}
