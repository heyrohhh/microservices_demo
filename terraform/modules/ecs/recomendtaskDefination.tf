resource "aws_cloudwatch_log_group" "ecs_recomandation" {
  name = "/ecs/recomandation"
  retention_in_days = 1
  tags = {
    Environment = "dev"
    Application = "recomandation"
  }
}

resource "aws_ecs_task_definition" "recomandation" {
  depends_on  =[aws_cloudwatch_log_group.ecs_recomandation]
  family= "recomandation"
  network_mode = var.network_mode
  requires_compatibilities = var.compatibilities
  cpu = var.cpu
  memory = var.memory
  execution_role_arn= aws_iam_role.task_execution_role.arn

  container_definitions = jsonencode([
    {
      name= "recomandation"
      image = var.recomandation_image
      essential = true
      portMappings = [
        {
          containerPort = 8080
          protocol = "tcp"
        }
      ]
      environment = [
        { name = "PORT", value = "8080" },
        { name ="PRODUCT_CATALOG_SERVICE_ADDR", value = "product.${var.service_discovery_namespace}:3550" }
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group =aws_cloudwatch_log_group.ecs_recomandation.name
          awslogs-region= var.aws_region
          awslogs-stream-prefix = "ecs"
        }
      }
    }
  ])
}

