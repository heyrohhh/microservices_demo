
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


