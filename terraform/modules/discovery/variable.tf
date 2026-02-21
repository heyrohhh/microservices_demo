variable "namespace_name" {
  type = string
  default = "local" 
}

variable "vpc_id" {
  type =string
}

variable "service_names" {
  type = list(string)
  default = [
    "adservice",
    "cart",
    "checkout",
    "currency",
    "email",
    "frontend",
    "loadGenrator",
    "payment",
    "product",
    "recomandation",
    "redis",
    "shipping",
    "shoppingassistant"
  ]
}
