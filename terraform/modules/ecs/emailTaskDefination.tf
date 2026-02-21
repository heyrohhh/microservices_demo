resource "aws_cloudwatch_log_group" "ecs_email" {
  name  = "/ecs/email"
  retention_in_days = 1
  tags = {
    environment = "dev"
    Application = "email"
  }
}

resource "aws_ecs_task_definition" "email" {
  depends_on = [aws_cloudwatch_log_group.ecs_email]
  family = "ecsEmail"
  network_mode= var.network_mode
  cpu  = var.cpu
  memory  = var.memory
  requires_compatibilities = var.compatibilities
  execution_role_arn = aws_iam_role.task_execution_role.arn

  container_definitions = jsonencode([
    {
      name = "email"
      image= var.email_Img
      essential = true
      portMappings = [
        {
          containerPort = 8080
          protocol = "tcp"
        }
      ]
      environment = [
        { name = "PORT", value = "8080" }
      ]
      logConfiguration = {
        logDriver="awslogs"
        options = {
          awslogs-group = aws_cloudwatch_log_group.ecs_email.name
          awslogs-region = var.aws_region
          awslogs-stream-prefix = "ecs"
        }
      }
    }
  ])
}
