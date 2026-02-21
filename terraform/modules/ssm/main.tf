data "aws_ssm_parameter" "foo" {
  name = "ssm_para"
  type  = var.type
  value = var.value
}