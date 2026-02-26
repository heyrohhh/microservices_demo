resource "aws_cloudwatch_log_group" "ecs_grafana" {
  name = "/etc/grafana"
  retention_in_days = 1

  tags = {
    Environment = "Dev"
    Application = "Grafana"
  }
}

resource "aws_ecs_task_definition" "garfana" {
  depends_on = [ aws_cloudwatch_log_group.ecs_grafana ]
  family = "Grafana"
  cpu = var.cpu
  memory = var.memory
  requires_compatibilities = var.compatibilities
  network_mode = var.network_mode
  execution_role_arn = aws_iam_role.task_execution_role.arn
container_definitions = jsonencode([
    {
        name="Grafana"
        image = "grafana/grafana"
        essential = true
        portMappings = [
            {
                containerPort = 3000
                protocol = "tcp"
            }
        ]

       environment = [
      {
    name  = "GF_SERVER_ROOT_URL"
    value = "%(protocol)s://%(domain)s/grafana/"
  }
]

     secrets = [
          {
          name      = "GF_SECURITY_ADMIN_USER"
        valueFrom = "arn:aws:secretsmanager:us-east-1:985017008178:secret:GF_SECURITY_ADMIN_USER-xMu4ly"
      },
  {
    name      = "GF_SECURITY_ADMIN_PASSWORD"
    valueFrom = "arn:aws:secretsmanager:us-east-1:985017008178:secret:GF_SECURITY_ADMIN_PASSWORD-Rwxzvg"
  }
]

       logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group = aws_cloudwatch_log_group.ecs_grafana.name
          awslogs-region= var.aws_region
          awslogs-stream-prefix = "ecs"
        }
      }
        

    }
])
}


#service 

resource "aws_ecs_service" "grafana_service" {
      name = "grafana-service"
     
      cluster = aws_ecs_cluster.ecs_cluster.id
      task_definition = aws_ecs_task_definition.garfana.arn
      desired_count = 1
      launch_type = "FARGATE"
      depends_on = [var.alb_listener_arn]
      network_configuration {
           subnets = var.private_subnet_ids
           security_groups = [var.grafana_sg_id]
           assign_public_ip = false
      }

      load_balancer {
           target_group_arn = var.grafana_tg
           container_name = "Grafana"
           container_port = 3000
      }

}