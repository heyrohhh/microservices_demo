variable "frontend_image" {
  type = string
}

variable "aws_region" {
  default = "us-east-1"
}


variable "ad_image" {
  type = string
}
variable "cart_image" {
  type = string
}
variable "checkout_image" {
  type = string
}
variable "currency_img" {
  type = string
}
variable "email_Img" {
  type = string
}
variable "load_Img" {
  type = string
}
variable "payment_image" {
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
  default = "512"
}
variable "memory" {
  default = "1024"
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

variable "alb_target_group_arn_suffix" {
    type = string
}

variable "alb_arn_suffix" {
  type = string
}

variable "eprom_sg_id" {
           type = string
}

variable "private_subnet_ids" {
    type = list(string)
}


variable "prometheus" {
  type = string 
}
variable "alertmanager" {
  type = string
}