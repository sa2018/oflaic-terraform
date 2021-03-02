resource "aws_security_group" "alb" {
  name        = "${var.name}-alb"
  description = "Allow TLS/HTTP inbound traffic"
  vpc_id      = var.vpc_id

  ingress {
    description = "TLS from Anywhere"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [
    "0.0.0.0/0"] #tfsec:ignore:AWS008
  }

  ingress {
    description = "HTTP from Anywhere"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [
    "0.0.0.0/0"] #tfsec:ignore:AWS008
  }

  egress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    cidr_blocks = [
    "0.0.0.0/0"] #tfsec:ignore:AWS009
  }

  tags = merge({
    "Name" = "${var.name}-alb"
  }, var.tags)

}

resource "aws_lb" "alb" {
  name                       = "${var.name}-alb"
  tags                       = var.tags
  internal                   = false #tfsec:ignore:AWS005
  load_balancer_type         = "application"
  security_groups            = [aws_security_group.alb.id]
  subnets                    = var.subnets
  enable_deletion_protection = false
}


resource "aws_alb_target_group" "api" {
  name        = "${var.name}-api"
  port        = var.backend_container_port
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "ip"

  health_check {
    healthy_threshold   = "3"
    interval            = "30"
    protocol            = "HTTP"
    matcher             = "200"
    timeout             = "3"
    path                = "/api/users"
    unhealthy_threshold = "2"
  }

  depends_on = [
    aws_lb.alb,
  ]

  tags = var.tags
}

resource "aws_alb_listener" "api" {
  load_balancer_arn = aws_lb.alb.id
  port              = 80 #tfsec:ignore:AWS004
  protocol          = "HTTP"

  default_action {
    type = "fixed-response"

    fixed_response {
      status_code  = "404"
      content_type = "text/plain"
      message_body = "Hello world"
    }
  }
}

resource "aws_alb_listener_rule" "api_rule" {
  listener_arn = aws_alb_listener.api.arn
  priority     = 100

  action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.api.arn
  }

  condition {
    path_pattern {
      values = ["/api/*"]
    }
  }
}
