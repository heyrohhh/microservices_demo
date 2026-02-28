variable "vpc_id" {
     type = string
}

variable "alb_security_group_id" {
      type = string
}


variable "public_subnet_ids" {
     type = list(string)
}

variable "private_subnet_ids" {
    type = list(string)
}

variable "prom_alb_sg_id" {
    type = string
}



variable "alert_sg_id" {
   type = string
}

variable "grafna_sg_id" {
  type = string
}