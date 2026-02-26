resource "aws_appautoscaling_target" "as_ecs" {
  for_each = var.services
  depends_on = [aws_ecs_service.services]
  max_capacity= each.value.max_capacity
  min_capacity= each.value.min_capacity
  resource_id = "service/${aws_ecs_cluster.ecs_cluster.name}/${each.key}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
}

resource "aws_appautoscaling_policy" "ecs_policy" {
  for_each = aws_appautoscaling_target.as_ecs
  name = "scale-cpu-${each.key}"
  policy_type= "TargetTrackingScaling"
  resource_id = each.value.resource_id
  scalable_dimension= each.value.scalable_dimension
  service_namespace = each.value.service_namespace

target_tracking_scaling_policy_configuration {
  predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageCPUUtilization"
    }
    target_value = 70.0
  }
}

#for frontend only alb request based scalling

resource "aws_appautoscaling_target" "as_ecs_frontend" {
  depends_on = [aws_ecs_service.frontend]
  max_capacity= 5
  min_capacity= 1
  resource_id = "service/${aws_ecs_cluster.ecs_cluster.name}/${aws_ecs_service.frontend.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
}

resource "aws_appautoscaling_policy" "ecs_policy_frontend" {
  depends_on = [ aws_appautoscaling_target.as_ecs_frontend ]
  name = "scale accordingly traffic"
  policy_type= "TargetTrackingScaling"
  resource_id = "service/${aws_ecs_cluster.ecs_cluster.name}/${aws_ecs_service.frontend.name}"
  scalable_dimension= "ecs:service:DesiredCount"
  service_namespace = "ecs"

target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ALBRequestCountPerTarget"
      resource_label = "${var.alb_arn_suffix}/${var.alb_target_group_arn_suffix}"
    }
    target_value       = 80.0 
    scale_in_cooldown  = 300   
    scale_out_cooldown = 60   
  }
}

resource "aws_appautoscaling_policy" "ecs_policy_frontend_cpu" {
   depends_on = [ aws_appautoscaling_target.as_ecs_frontend ]
  name = "scale accordingly cpu"
  policy_type= "TargetTrackingScaling"
  resource_id = "service/${aws_ecs_cluster.ecs_cluster.name}/${aws_ecs_service.frontend.name}"
  scalable_dimension= "ecs:service:DesiredCount"
  service_namespace = "ecs"

target_tracking_scaling_policy_configuration {
  predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageCPUUtilization"
    }
    target_value = 70.0
  }
}