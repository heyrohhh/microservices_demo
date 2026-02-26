output "namespace_id" {
  description = "Service discovery namespace ID"
  value       = aws_service_discovery_private_dns_namespace.namespace.id
}

output "namespace_name" {
  description = "Service discovery namespace name"
  value       = aws_service_discovery_private_dns_namespace.namespace.name
}

output "namespace_arn" {
  description = "Service discovery namespace ARN"
  value       = aws_service_discovery_private_dns_namespace.namespace.arn
}

output "service_registry_arns" {
  value = {
    for k, v in aws_service_discovery_service.services :
    k => v.arn
  }
}

output "service_ids" {
  description = "Map of service names to their IDs"
  value = {
    for name, service in aws_service_discovery_service.services : 
    name => service.id
  }
}