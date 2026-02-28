output "alb_security_group_id" {
  value = aws_security_group.alb_sg.id
  description = "Security Group ID for Application Load Balancer"
}

output "ecs_security_group_id" {
  value = aws_security_group.ecs_sg.id
  description = "Security Group ID for ECS tasks"
}

output "prom_sg_id" {
   value = aws_security_group.prom_sg.id
  description = "Security Group ID for prometheus alb"
}

output "prom_alb_sg_id" {
  value = aws_security_group.prom_alb_sg.id
}

output "alert_sg_id" {
  value = aws_security_group.alert_sg.id
}

output "grafna_sg_id" {
  value = aws_security_group.grafna_sg.id
}