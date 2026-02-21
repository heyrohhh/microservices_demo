resource "aws_cloudwatch_log_group" "ecs_cart" {
  name = "/ecs/cart"
  retention_in_days = 1
  tags = {
    environment="dev"
    Application ="cart"
  }
}

resource "aws_ecs_task_definition" "cart" {
  depends_on = [aws_cloudwatch_log_group.ecs_cart]
  family ="cart"
  network_mode= var.network_mode
  requires_compatibilities =var.compatibilities
  cpu =var.cpu
  memory = var.memory
  execution_role_arn =aws_iam_role.task_execution_role.arn

  container_definitions = jsonencode([
    {
      name  = "ecsCart"
      image  = var.cart_image
      essential = true
      portMappings = [
        {
          containerPort = 7070
          protocol = "tcp"
        }
      ]
      environment = [
        { name = "PORT", value = "7070" },
        { name = "REDIS_ADDR", value = "redis.${var.service_discovery_namespace}:6379" }
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group = aws_cloudwatch_log_group.ecs_cart.name
          awslogs-region  = var.aws_region
          awslogs-stream-prefix = "ecs"
        }
      }
    }
  ])
}
