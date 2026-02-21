output "alb_id" {
  value       = aws_lb.alb_lb.id
  description = "Application Load Balancer ID"
}

output "alb_arn" {
  value       = aws_lb.alb_lb.arn
  description = "Application Load Balancer ARN"
}

output "alb_target_group_arn" {
  value       = aws_lb_target_group.alb_tg.arn
  description = "Target Group ARN for ECS service"
}


output "alb_listener_arn" {
  value       = aws_lb_listener.alb_listener.arn
  description = "ALB Listener ARN"
}
