#alb Security group

resource "aws_security_group" "alb_sg" {
    name = "alb-sg"
    vpc_id = var.vpc_id

    tags = {
        Name = "alb_sg"
    }

    ingress {
         from_port = 80
         to_port = 80
         protocol = "tcp"
         cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
         from_port = 0
         to_port = 0
         protocol = "-1"
         cidr_blocks = ["0.0.0.0/0"]
    }
}


#ecs Security group

resource "aws_security_group" "ecs_sg" {
    name   = "ecs-sg"
    vpc_id = var.vpc_id

    tags = {
        Name = "ecs_sg"
    }

    # Allow from ALB on port 8080 (frontend)
    ingress {
        description= "Allow traffic from ALB on port 8080"
        security_groups = [aws_security_group.alb_sg.id]
        from_port= 8080
        to_port= 8080
        protocol= "tcp"
    }

    # Allow from ALB on port 7070 (cart)
    ingress {
        description= "Allow traffic from ALB on port 7070"
        security_groups = [aws_security_group.alb_sg.id]
        from_port= 7070
        to_port = 7070
        protocol= "tcp"
    }

    # Allow from ALB on port 3550 (product)
    ingress {
        description = "Allow traffic from ALB on port 3550"
        security_groups = [aws_security_group.alb_sg.id]
        from_port= 3550
        to_port = 3550
        protocol = "tcp"
    }

    ingress {
        description = "Allow ECS tasks to communicate with each other"
        self = true
        from_port= 0
        to_port= 65535
        protocol= "tcp"
    }

    egress {
        from_port= 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}


resource "aws_security_group" "prom_sg" {
      name   = "prom-sg"
    vpc_id = var.vpc_id

    tags = {
        Name = "prom_sg"
    }

    ingress {
        description = "allow prom_sg to communicate with frontend"
        security_groups = [aws_security_group.alb_sg.id]
        from_port = 9090
        to_port = 9090
        protocol = "tcp"
    }

    egress {
        from_port= 0
        to_port = 0
        protocol = "-1"
        cidr_blocks  = ["0.0.0.0/0"]
    }
}


#alertmanager security group

resource "aws_security_group" "alert_sg" {
      name   = "alert-sg"
    vpc_id = var.vpc_id

    tags = {
        Name = "alert_sg"
    }

   ingress {
  description  = "allow ALB to reach alertmanager"
  security_groups = [aws_security_group.alb_sg.id]
  from_port  = 9093
  to_port  = 9093
  protocol = "tcp"
}

ingress {
  description     = "allow prometheus to push alerts"
  security_groups = [aws_security_group.prom_sg.id]
  from_port = 9093
  to_port   = 9093
  protocol= "tcp"
}

    egress {
        from_port= 0
        to_port = 0
        protocol = "-1"
        cidr_blocks  = ["0.0.0.0/0"]
    }
}