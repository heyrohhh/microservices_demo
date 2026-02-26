variable "namespace_name" {
  type = string
  default = "local" 
}

variable "vpc_id" {
  type =string
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
