resource "aws_cloudwatch_log_group" "ecs_redisex" {
  name= "/ecs/redisexporter"
  retention_in_days = 1
  tags = {
    Environment = "dev"
    Application = "redis-exporter"
  }
}

resource "aws_ecs_task_definition" "redis_exporter" {
   depends_on = [ aws_cloudwatch_log_group.ecs_redisex ]
   family = "redis-exporter"
   network_mode = var.network_mode
   cpu = var.cpu
   memory = var.memory
   requires_compatibilities = var.compatibilities
   execution_role_arn = aws_iam_role.task_execution_role.arn

   container_definitions = jsonencode([
   {
     name = "redis-exporter"
     image = "oliver006/redis_exporter"
     essential = true
     portMappings = [
        {
            containerPort = 9121
            protocol = "tcp"
        }
     ]
     environment = [
        {    
            "name" = "REDIS_ADDR"
            "value"= "redis://redis.local:6379"
        }
     ]

     logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group = aws_cloudwatch_log_group.ecs_redisex.name
          awslogs-region= var.aws_region
          awslogs-stream-prefix = "ecs"
        }
      }
   }
   ])

}


resource "aws_ecs_service" "redis_exporter_service" {
        name = "redis-exporter"
        cluster = aws_ecs_cluster.ecs_cluster.id
        task_definition = aws_ecs_task_definition.redis_exporter.arn
        desired_count = 1
        launch_type = "FARGATE"

        network_configuration {
        subnets = var.private_subnet_ids
        security_groups  = [var.ecs_security_group_id]
        assign_public_ip = false
  }


service_registries {
     registry_arn = var.monitor_service_arns["redis-exporter"] 
}
}