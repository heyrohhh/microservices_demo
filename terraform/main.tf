module "vpc" {
  source = "./modules/vpc"
}

module "sg" {
  source = "./modules/sg"
  vpc_id = module.vpc.vpc_id
}

module "alb" {
  source = "./modules/alb"
  vpc_id = module.vpc.vpc_id
  public_subnet_ids = module.vpc.public_subnet_ids
  alb_security_group_id = module.sg.alb_security_group_id
  private_subnet_ids = module.vpc.private_subnet_ids
  prom_sg_id = module.sg.prom_sg_id
  alert_sg_id = module.sg.alert_sg_id
  grafna_sg_id = module.sg.grafna_sg_id
}

module "discovery" {
  source = "./modules/discovery"

  vpc_id = module.vpc.vpc_id
  namespace_name = "local"
  services = var.services
}

module "ecs" {
  source   = "./modules/ecs"
  private_subnet_ids = module.vpc.private_subnet_ids
  ecs_security_group_id  = module.sg.ecs_security_group_id
  alb_target_group_arn= module.alb.alb_target_group_arn
  alb_listener_arn  = module.alb.alb_listener_arn
  aws_region  = var.aws_region
  frontend_image= var.frontend_image
  ad_image  = var.ad_image
  cart_image  = var.cart_image
  checkout_image = var.checkout_image
  currency_img = var.currency_img
  email_Img = var.email_Img
  load_Img = var.load_Img
  payment_image = var.payment_image
  product_image  = var.product_image
  recomandation_image  = var.recomandation_image
  shipping_image = var.shipping_image
  assitant_image = var.assitant_image
  prometheus = var.prometheus
  alertmanager = var.alertmanager
  service_discovery_namespace = module.discovery.namespace_name
  cpu  = var.cpu
  memory = var.memory
  discovery_arns = module.discovery.service_registry_arns
  alb_arn_suffix = module.alb.alb_arn_suffix
  alb_target_group_arn_suffix = module.alb.alb_target_group_arn_suffix
  alb_target_group_prom_arn = module.alb.alb_target_group_arn
  prom_sg_id = module.sg.prom_sg_id
  services = var.services
  service_arns = module.discovery.service_registry_arns
  alert_sg_id = module.sg.alert_sg_id
  alarm_tg = module.alb.alarm_tg
  grafana_sg_id = module.sg.grafna_sg_id
  grafana_tg = module.alb.grafana_tg
}


