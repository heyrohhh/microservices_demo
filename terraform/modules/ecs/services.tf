resource "aws_ecs_service" "services" {
   for_each = var.services
   name = each.key
   cluster = aws_ecs_cluster.ecs_cluster.id
   task_definition = local.task_definitions[each.key]
   launch_type  = "FARGATE"
   desired_count = each.value.desired_count

  network_configuration {
    subnets  = var.private_subnet_ids
    security_groups  = [var.ecs_security_group_id]
    assign_public_ip = false
  }

 service_registries {
   registry_arn = var.service_arns[each.key]
}
}