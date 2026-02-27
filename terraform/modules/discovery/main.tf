resource "aws_service_discovery_private_dns_namespace" "namespace" {
  name = var.namespace_name
  vpc =var.vpc_id
}

resource "aws_service_discovery_service" "services" {
  for_each = var.services

  name = each.key

  dns_config {
    namespace_id = aws_service_discovery_private_dns_namespace.namespace.id

    dns_records {
      type = "A"
      ttl  = 10
    }
  }
}

resource "aws_service_discovery_service" "monitor_services" {
  for_each = var.monitorneeds

  name = each.value

  dns_config {
    namespace_id = aws_service_discovery_private_dns_namespace.namespace.id

    dns_records {
      type = "A"
      ttl  = 10
    }
  }
}


