variable "namespace_name" {
  type = string
  default = "local" 
}

variable "vpc_id" {
  type =string
}

variable "services" {
  type = list(string)
}
