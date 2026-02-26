
#target group frontend

resource "aws_lb_target_group" "alb_tg" {
  name = "frontend-tg"
  port = 8080
  protocol = "HTTP"
  vpc_id = var.vpc_id
  target_type = "ip"

  health_check {
    path = "/"
    interval = 10
    timeout = 5
    healthy_threshold = 3
    unhealthy_threshold = 2
    matcher  = "200"
  }
}


# load Balancer

resource "aws_lb" "alb_lb" {
      name = "aws-lb"
      internal = false
      load_balancer_type = "application"
      security_groups = [var.alb_security_group_id]
      subnets = var.public_subnet_ids
      enable_deletion_protection = false
      
      tags = {
         Name = "aws-lb"
  }

}

# aws listner


resource "aws_lb_listener" "alb_listener" {
    load_balancer_arn = aws_lb.alb_lb.arn
    port = 80
    protocol = "HTTP"
    default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.alb_tg.arn
  }
 }


#target group for prometheus

resource "aws_lb_target_group" "Prom_tg" {
  name = "prom-tg"
  port = 9090
  protocol = "HTTP"
  vpc_id = var.vpc_id
  target_type = "ip"

  health_check {
    path = "/-/healthy"
    interval = 10
    timeout = 5
    healthy_threshold = 2
    unhealthy_threshold = 2
    matcher = "200"
  }
}

#loadbalancer for prometheus

resource "aws_lb" "lb_prom" {
      name = "lb-prom"
      internal = true
      load_balancer_type = "application"
      security_groups = [var.prom_sg_id]
      subnets = var.private_subnet_ids
      enable_deletion_protection = false
      
      tags = {
         Name = "lb-prom"
  }

}



resource "aws_lb_listener" "prom_listner" {
  load_balancer_arn = aws_lb.lb_prom.arn
  port = 80
  protocol = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.Prom_tg.arn
  }
 
}


#target group for alertmanager

resource "aws_lb_target_group" "alarm_tg" {
    name = "alarm-tg"
  port = 9093
  protocol = "HTTP"
  vpc_id = var.vpc_id
  target_type = "ip"

  health_check {
    path = "/-/healthy"
    interval = 10
    timeout = 5
    healthy_threshold = 2
    unhealthy_threshold = 2
    matcher = "200"
  }
}



resource "aws_lb_listener_rule" "alert_rule" {
  listener_arn = aws_lb_listener.prom_listner.arn
  priority     = 10

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.alarm_tg.arn
  }

  condition {
    path_pattern {
      values = ["/alertmanager*"]
    }
  }
}