resource "aws_cloudwatch_log_group" "ecs_am" {
  name= "/ecs/alertmanager"
  retention_in_days = 1
  tags = {
    Environment = "dev"
    Application = "alertmanager"
  }
}

resource "aws_ecs_task_definition" "alertmanager" {
   depends_on = [ aws_cloudwatch_log_group.ecs_am ]
   family = "alertmanager"
   network_mode = var.network_mode
   cpu = var.cpu
   memory = var.memory
   requires_compatibilities = var.compatibilities
   execution_role_arn = aws_iam_role.task_execution_role.arn
   task_role_arn = aws_iam_role.task_role.arn

   container_definitions = jsonencode([
   {
     name = "alertmanager"
     image = var.alertmanager
     essential = true
     portMappings = [
        {
            containerPort = 9093
            protocol = "tcp"
        }
     ]
      
 secrets = [
      {
        name      = "TELEGRAM_BOT_TOKEN"
        valueFrom = "arn:aws:secretsmanager:us-east-1:985017008178:secret:TELEGRAM_BOT_TOKEN-BTvHit"
      }
    ]

     logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group = aws_cloudwatch_log_group.ecs_am.name
          awslogs-region= var.aws_region
          awslogs-stream-prefix = "ecs"
        }
      }
   }
   ])

}


resource "aws_ecs_service" "am_service" {
        name = "alertmanager"
        cluster = aws_ecs_cluster.ecs_cluster.id
        task_definition = aws_ecs_task_definition.alertmanager.arn
        desired_count = 1
        launch_type = "FARGATE"

        network_configuration {
        subnets = var.private_subnet_ids
        security_groups  = [var.alert_sg_id]
        assign_public_ip = false
  }

  load_balancer {
  target_group_arn = var.alarm_tg
  container_name   = "alertmanager"
  container_port   = 9093
}

service_registries {
     registry_arn = var.monitor_service_arns["alertmanager"]
}
}