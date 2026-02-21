resource "aws_cloudwatch_log_group" "ecs_loadgenrator" {
  name = "/ecs/loadgenerator"
  retention_in_days = 1
  tags = {
    environment = "dev"
    Application = "ecsGenrator"
  }
}

resource "aws_ecs_task_definition" "loadgenrator" {
  depends_on = [aws_cloudwatch_log_group.ecs_loadgenrator]
  family  = "loadgenrator"
  network_mode =var.network_mode
  cpu =var.cpu
  memory=var.memory
  requires_compatibilities=var.compatibilities
  execution_role_arn= aws_iam_role.task_execution_role.arn

  container_definitions = jsonencode([
    {
      name = "load-generator"
      image = var.load_Img
      essential = true
      portMappings = [
        {
          containerPort = 8080
          protocol = "tcp"
        }
      ]
      environment = [
        { name = "PORT", value = "8080" },
        { name ="FRONTEND_ADDR", value = "frontend.${var.service_discovery_namespace}:8080" }
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group = aws_cloudwatch_log_group.ecs_loadgenrator.name
          awslogs-region = var.aws_region
          awslogs-stream-prefix = "ecs"
        }
      }
    }
  ])
}
