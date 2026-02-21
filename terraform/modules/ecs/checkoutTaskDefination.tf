resource "aws_cloudwatch_log_group" "ecs_checkout" {
  name  = "/ecs/checkout"
  retention_in_days = 1
  tags = {
    environment = "dev"
    application = "checkout"
  }
}

resource "aws_ecs_task_definition" "checkout" {
  depends_on  = [aws_cloudwatch_log_group.ecs_checkout]
  family = "checkout"
  network_mode = var.network_mode
  cpu   = var.cpu
  memory = var.memory
  requires_compatibilities = var.compatibilities
  execution_role_arn       = aws_iam_role.task_execution_role.arn

  container_definitions = jsonencode([
    {
      name  = "ecsCheckout"
      image  = var.checkout_image
      essential = true
      portMappings = [
        {
          containerPort = 5050
          protocol  = "tcp"
        }
      ]
      environment = [
        { name = "PORT", value = "5050" },
        { name= "PRODUCT_CATALOG_SERVICE_ADDR", value = "product.${var.service_discovery_namespace}:3550" },
        { name= "SHIPPING_SERVICE_ADDR", value = "shipping.${var.service_discovery_namespace}:50051" },
        { name ="PAYMENT_SERVICE_ADDR", value = "payment.${var.service_discovery_namespace}:50051" },
        { name ="EMAIL_SERVICE_ADDR", value = "email.${var.service_discovery_namespace}:8080" },
        { name= "CURRENCY_SERVICE_ADDR", value = "currency.${var.service_discovery_namespace}:7000" },
        { name = "CART_SERVICE_ADDR", value = "cart.${var.service_discovery_namespace}:7070" }
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group  =aws_cloudwatch_log_group.ecs_checkout.name
          awslogs-region= var.aws_region
          awslogs-stream-prefix = "ecs"
        }
      }
    }
  ])
}
