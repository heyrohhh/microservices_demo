resource "aws_cloudwatch_log_group" "ecs_currency" {
  name = "/ecs/currency"
  retention_in_days = 1
  tags = {
    Environment = "dev"
    Application = "currency"
  }
}

resource "aws_ecs_task_definition" "currency" {
  depends_on    = [aws_cloudwatch_log_group.ecs_currency]
  family  = "currency"
  network_mode = var.network_mode
  requires_compatibilities = var.compatibilities
  cpu = var.cpu
  memory  = var.memory
  execution_role_arn= aws_iam_role.task_execution_role.arn

  container_definitions = jsonencode([
    {
      name = "ecsCurrency"
      image = var.currency_img
      essential = true
      portMappings = [
        {
          containerPort = 7000
          protocol= "tcp"
        }
      ]
      environment = [
        { name = "PORT", value = "7000" },
        { name = "DISABLE_PROFILER", value = "1" }
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group  = aws_cloudwatch_log_group.ecs_currency.name
          awslogs-region = var.aws_region
          awslogs-stream-prefix = "ecs"
        }
      }
    }
  ])
}
