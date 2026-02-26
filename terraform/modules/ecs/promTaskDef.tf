resource "aws_cloudwatch_log_group" "ecs_prom" {
  name= "/ecs/prometheus"
  retention_in_days = 1
  tags = {
    Environment = "dev"
    Application = "prometheus"
  }
}

resource "aws_ecs_task_definition" "prometheus" {
     depends_on = [ aws_cloudwatch_log_group.ecs_prom ]
     family = "prometheus"
     network_mode = var.network_mode
     cpu = var.cpu
     memory = var.memory
     execution_role_arn = aws_iam_role.task_execution_role.arn
     requires_compatibilities = var.compatibilities
     container_definitions = jsonencode([
    {
      name= "prometheus"
      image= var.prometheus
      essential = true
      portMappings = [
        {
          containerPort = 9090
          protocol= "tcp"
        }
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group = aws_cloudwatch_log_group.ecs_prom.name
          awslogs-region= var.aws_region
          awslogs-stream-prefix = "ecs"
        }
      }
      healthCheck={
              command  = ["CMD-SHELL", "wget -qO- http://localhost:9090/-/healthy || exit 1"]
              interval = 30
              timeout  = 5
              retries  = 3
              startPeriod = 60
      }
     
    
    }
  ])
}

#service prometheus

resource "aws_ecs_service" "prom_service" {
  name= "prom-service"
  cluster =aws_ecs_cluster.ecs_cluster.id
  task_definition = aws_ecs_task_definition.prometheus.arn
  desired_count= 1
  launch_type= "FARGATE"
  
  network_configuration {
    subnets = var.private_subnet_ids
    security_groups  = [var.prom_sg_id]
    assign_public_ip = false
  }

   load_balancer {
    target_group_arn = var.alb_target_group_prom_arn
    container_name = "prometheus"
    container_port= 9090 
  }

}