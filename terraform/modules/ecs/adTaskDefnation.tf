resource "aws_cloudwatch_log_group" "ecs_adtask" {
  name  = "/ecs/adtask"
  retention_in_days = 1
  tags = {
    Environment = "dev"
    Application = "ad"
  }
}
#task defination hd
resource "aws_ecs_task_definition" "adtask" {
  depends_on = [aws_cloudwatch_log_group.ecs_adtask]
  family = "ad"
  network_mode= var.network_mode
  requires_compatibilities = var.compatibilities
  cpu = var.cpu
  memory= var.memory
  execution_role_arn= aws_iam_role.task_execution_role.arn

  container_definitions = jsonencode([
    {
      name = "ecsAd"
      image = var.ad_image
      essential = true
      portMappings = [
        {
          containerPort = 9555
          protocol  = "tcp"
        }
      ]
      environment = [
        { name = "PORT", value = "9555" }
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group = aws_cloudwatch_log_group.ecs_adtask.name
          awslogs-region  = var.aws_region
          awslogs-stream-prefix = "ecs"
        }
      }
    }
  ])
}
