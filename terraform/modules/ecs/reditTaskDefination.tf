resource "aws_cloudwatch_log_group" "ecs_redis" {
  name  = "/ecs/redis"
  retention_in_days = 1
  tags = {
    Environment ="dev"
    Application = "redis"
  }
}

resource "aws_ecs_task_definition" "redis" {
  depends_on= [aws_cloudwatch_log_group.ecs_redis]
  family= "redis"
  network_mode= var.network_mode
  requires_compatibilities = var.compatibilities
  cpu=var.cpu
  memory =var.memory
  execution_role_arn = aws_iam_role.task_execution_role.arn

  container_definitions = jsonencode([
    {
      name= "redis"
      image= "redis:7.2-alpine"
      essential = true
      portMappings = [
        {
          containerPort = 6379
          protocol= "tcp"
        }
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group = aws_cloudwatch_log_group.ecs_redis.name
          awslogs-region= var.aws_region
          awslogs-stream-prefix = "ecs"
        }
      }
    }
  ])
}
