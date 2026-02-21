resource "aws_cloudwatch_log_group" "ecs_shipping" {
  name = "/ecs/shipping"
  retention_in_days = 1
  tags = {
    Environment = "dev"
    Application ="shipping"
  }
}

resource "aws_ecs_task_definition" "shipping" {
  depends_on= [aws_cloudwatch_log_group.ecs_shipping]
  family  = "shipping"
  network_mode = var.network_mode
  requires_compatibilities = var.compatibilities
  cpu = var.cpu
  memory = var.memory
  execution_role_arn =aws_iam_role.task_execution_role.arn

  container_definitions = jsonencode([
    {
      name = "shipping"
      image= var.shipping_image
      essential = true
      portMappings = [
        {
          containerPort = 50051
          protocol ="tcp"
        }
      ]
      environment = [
        { name ="PORT", value = "50051" }
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group=aws_cloudwatch_log_group.ecs_shipping.name
          awslogs-region= var.aws_region
          awslogs-stream-prefix = "ecs"
        }
      }
    }
  ])
}
