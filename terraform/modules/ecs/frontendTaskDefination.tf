resource "aws_cloudwatch_log_group" "ecs_frontend" {
  name= "/ecs/frontend"
  retention_in_days = 1
  tags = {
    Environment = "production"
    Application ="frontend"
  }
}

resource "aws_ecs_task_definition" "frontend_service" {
  depends_on = [aws_cloudwatch_log_group.ecs_frontend]
  family= "frontend-service"
  network_mode= var.network_mode
  requires_compatibilities = var.compatibilities
  cpu= var.cpu
  memory = var.memory
  execution_role_arn = aws_iam_role.task_execution_role.arn

  container_definitions = jsonencode([
    {
      name  = "frontend"
      image= var.frontend_image
      essential = true
      portMappings = [
        {
          containerPort = 8080
          protocol      = "tcp"
        }
      ]
      environment = [
        { name = "PORT", value = "8080" },
        { name= "PRODUCT_CATALOG_SERVICE_ADDR", value = "product.${var.service_discovery_namespace}:3550" },
        { name= "CURRENCY_SERVICE_ADDR", value = "currency.${var.service_discovery_namespace}:7000" },
        { name="CART_SERVICE_ADDR", value = "cart.${var.service_discovery_namespace}:7070" },
        { name="RECOMMENDATION_SERVICE_ADDR", value = "recomandation.${var.service_discovery_namespace}:8080" },
        { name="SHIPPING_SERVICE_ADDR", value = "shipping.${var.service_discovery_namespace}:50051" },
        { name ="CHECKOUT_SERVICE_ADDR", value = "checkout.${var.service_discovery_namespace}:5050" },
        { name= "AD_SERVICE_ADDR", value = "adservice.${var.service_discovery_namespace}:9555" },
        { name = "SHOPPING_ASSISTANT_SERVICE_ADDR", value = "shoppingassistant.${var.service_discovery_namespace}:8080" }
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group= aws_cloudwatch_log_group.ecs_frontend.name
          awslogs-region= var.aws_region
          awslogs-stream-prefix = "ecs"
        }
      }
    }
  ])
}
