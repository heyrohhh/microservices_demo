resource "aws_ecs_service" "cart_service" {
  name = "cart-service"
  cluster = aws_ecs_cluster.ecs_cluster.id
  task_definition = aws_ecs_task_definition.cart.arn
  desired_count = 2
  launch_type = "FARGATE"

  network_configuration {
    subnets = var.private_subnet_ids
    security_groups  = [var.ecs_security_group_id]
    assign_public_ip = false
  }

  service_registries {
    registry_arn = var.discovery_arns["cart"]
  }

}