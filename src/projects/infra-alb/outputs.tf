output "alb_arn" {
  value = aws_lb.alb.arn
}

output "alb_sg" {
  value = aws_security_group.alb.id
}
output "api_target_group_arn" {
  value = aws_alb_target_group.api.arn
}

output "api_resource" {
  value = "http://${aws_lb.alb.dns_name}/api/users"
}
