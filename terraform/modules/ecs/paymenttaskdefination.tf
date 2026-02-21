resource "aws_cloudwatch_log_group" "ecs_payment" {
  name = "/ecs/payment"
  retention_in_days = 1
  tags = {
    Environment = "dev"
    Application = "payment"
  }
}

resource "aws_ecs_task_definition" "payment" {
  depends_on = [aws_cloudwatch_log_group.ecs_payment]
  family= "payment"
  network_mode= var.network_mode
  requires_compatibilities = var.compatibilities
  cpu = var.cpu
  memory= var.memory
  execution_role_arn= aws_iam_role.task_execution_role.arn

  container_definitions = jsonencode([
    {
      name = "payment"
      image= var.payment_image
      essential = true
      portMappings = [
        {
          containerPort = 50051
          protocol= "tcp"
        }
      ]
      environment = [
        { name = "PORT", value = "50051" },
        { name = "DISABLE_PROFILER", value = "1" }
      ]
      logConfiguration = {
        logDriver ="awslogs"
        options ={
          awslogs-group=aws_cloudwatch_log_group.ecs_payment.name
          awslogs-region= var.aws_region
          awslogs-stream-prefix = "ecs"
        }
      }
    }
  ])
}
