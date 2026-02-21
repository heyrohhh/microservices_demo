resource "aws_cloudwatch_log_group" "ecs_product" {
  name  = "/ecs/product"
  retention_in_days = 1
  tags = {
    Environment = "dev"
    Application = "product"
  }
}

resource "aws_ecs_task_definition" "product" {
  depends_on =[aws_cloudwatch_log_group.ecs_product]
  family= "product"
  network_mode= var.network_mode
  requires_compatibilities = var.compatibilities
  cpu=var.cpu
  memory =var.memory
  execution_role_arn= aws_iam_role.task_execution_role.arn

  container_definitions = jsonencode([
    {
      name= "product"
      image= var.product_image
      essential = true
      portMappings = [
        {
          containerPort = 3550
          protocol= "tcp"
        }
      ]
      environment = [
        { name = "PORT", value = "3550" }
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group= aws_cloudwatch_log_group.ecs_product.name
          awslogs-region = var.aws_region
          awslogs-stream-prefix = "ecs"
        }
      }
    }
  ])
}
