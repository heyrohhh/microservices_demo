output "alb_id" {
  value = aws_lb.alb_lb.id
  description = "Application Load Balancer ID"
}

output "alb_arn" {
  value= aws_lb.alb_lb.arn
  description = "Application Load Balancer ARN"
}

output "alb_arn_suffix" {
  value = aws_lb.alb_lb.arn_suffix
   description = "Application Load Balancer ARN SUFFIX"
}

output "alb_target_group_arn" {
  value = aws_lb_target_group.alb_tg.arn
  description = "Target Group ARN for ECS service"
}

output "alb_target_group_arn_suffix" {
  value = aws_lb_target_group.alb_tg.arn_suffix
  description = "Target Group ARN SUFFIX for ECS service"
}

output "alb_listener_arn" {
  value= aws_lb_listener.alb_listener.arn
  description = "ALB Listener ARN"
}

output "alb_target_group_prom_arn" {
  value = aws_lb_target_group.Prom_tg.arn
   description = "Target Group ARN for Prometheus"
}

output "alarm_tg" {
  value = aws_lb_target_group.alarm_tg
}

output "alb_prom_id" {
  value = aws_lb.lb_prom.id
  description = "Application Load Balancer ID of prom"
}

output "alb_prom_arn" {
  value= aws_lb.lb_prom.arn
  description = "Application Load Balancer ARN"
}

output "alb_prom_listner" {
  value = aws_lb_listener.prom_listner.arn
}

output "grafana_tg_arn" {
  value = aws_lb_target_group.grafna_tg.arn
}