
variable "frontend_image" {
  type =string
}
variable "ad_image" {
   type = string 
}
variable "cart_image" {
  type =string
}
variable "checkout_image" {
  type = string
}
variable "currency_img" {
  type = string
}
variable "email_Img" {
  type =string
}
variable "load_Img" {
  type = string
}

variable "payment_image" {
  type = string
}

variable "prometheus" {
  type = string 
}

variable "alertmanager" {
  type = string
}


variable "product_image" {
  type = string
}
variable "recomandation_image" {
    type = string
}

variable "shipping_image" {
    type = string
}
variable "assitant_image" {
  type = string
}

variable "cpu" {
  type = string
  default = "512"
}

variable "memory" {
  type = string
  default = "1024"
}

variable "discovery_arns" {
  type= map(string)
}

variable "network_mode" {
   type = string
   default = "awsvpc"
}




variable "compatibilities" {
     type = set(string)
     default =[ "FARGATE"]
}
variable "private_subnet_ids" {
    type = list(string)
}

variable "ecs_security_group_id" {
     type = string
}

variable "alb_target_group_arn" {
    type = string
}

variable "alb_target_group_arn_suffix" {
    type = string
}

variable "alb_arn_suffix" {
  type = string
}

variable "alb_listener_arn" {
     type = string
}

variable "aws_region" {
  type = string

  validation {
    condition= length(var.aws_region) > 0
    error_message = "Region must be provided."
  }
}

variable "service_discovery_namespace" {
  description = "Service discovery namespace"
  type        = string
  default     = "local"  # or whatever your namespace is
}


variable "alb_target_group_prom_arn" {
    type = string 
}

variable "prom_sg_id" {
  type = string
}

variable "services" {
   type = map(object({
     desired_count = number
     min_capacity = number
     max_capacity = number
     cpu_target = number
     mem_target = number
      }))
}

variable "service_arns" {
    type = map(string)
}

variable "alert_sg_id" {
  type = string
}

variable "alarm_tg" {
  type = string
}

variable "grafana_tg" {
  type = string
}

variable "grafana_sg_id" {
 type = string 
}