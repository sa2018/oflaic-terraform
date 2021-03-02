resource "aws_ecs_cluster" "cluster" {

  name = var.name

  capacity_providers = [
    "FARGATE",
    "FARGATE_SPOT"
  ]

  default_capacity_provider_strategy {
    capacity_provider = "FARGATE"
    weight            = "2"
  }

  default_capacity_provider_strategy {
    capacity_provider = "FARGATE_SPOT"
    weight            = "4"
  }

  setting {
    name  = "containerInsights"
    value = "enabled"
  }

  tags = var.tags
}

