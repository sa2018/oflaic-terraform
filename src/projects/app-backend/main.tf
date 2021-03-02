resource "aws_security_group" "backend" {
  name        = "${var.name}-ecs"
  description = "Allow HTTP inbound traffic"
  vpc_id      = var.vpc_id

  ingress {
    description = "HTTP from ALB"
    from_port   = var.backend_container_port
    to_port     = var.backend_container_port
    protocol    = "tcp"
    security_groups = [
    var.api_alb_sg]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"] #tfsec:ignore:AWS009
  }

  tags = merge({
    "Name" = "${var.name}-ecs"
  }, var.tags)

}

resource "aws_ecs_task_definition" "backend" {
  family = var.name
  container_definitions = templatefile("${path.module}/task-definitions/service.json.tmpl", {
    port = var.backend_container_port,
    image : var.backend_container_image
  })
  tags = merge({
    "Name" = "${var.name}-backend",
    "Type" : "backend"
  }, var.tags)
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = "256"
  memory                   = "512"
}

resource "aws_ecs_service" "backend" {
  name                              = var.name
  cluster                           = var.cluster_id
  task_definition                   = aws_ecs_task_definition.backend.arn
  desired_count                     = var.size
  iam_role                          = "aws-service-role"
  health_check_grace_period_seconds = 0

  capacity_provider_strategy {
    base              = 0
    capacity_provider = "FARGATE"
    weight            = 2
  }
  capacity_provider_strategy {
    base              = 0
    capacity_provider = "FARGATE_SPOT"
    weight            = 4
  }

  deployment_controller {
    type = "ECS"
  }


  tags = merge({
    "Name" = var.name,
    "Type" : "backend"
  }, var.tags)
  lifecycle {
    ignore_changes = [
    desired_count]
  }

  network_configuration {
    subnets = var.subnets
    security_groups = [
    aws_security_group.backend.id]
  }

  load_balancer {
    target_group_arn = var.api_target_group_arn
    container_name   = var.name
    container_port   = var.backend_container_port
  }

}
