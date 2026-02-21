resource "aws_ecs_service" "frontend" {
  name= "frontend"
  cluster = aws_ecs_cluster.ecs_cluster.id
  task_definition = aws_ecs_task_definition.frontend_service.arn
  desired_count= 2
  launch_type = "FARGATE"

  network_configuration {
    subnets= var.private_subnet_ids
    security_groups= [var.ecs_security_group_id]
    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = var.alb_target_group_arn
    container_name = "frontend"
    container_port= 8080
  }

  depends_on =[var.alb_listener_arn]
}
