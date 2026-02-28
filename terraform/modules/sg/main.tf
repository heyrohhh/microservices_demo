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





resource "aws_security_group" "prom_alb_sg" {
  name   = "prom-alb-sg"
  vpc_id = var.vpc_id
  tags = { Name = "prom_alb_sg" }

  ingress {
    description     = "EC2 Bastion se Prometheus UI"
    from_port       = 9090
    to_port         = 9090
    protocol        = "tcp"
    security_groups = [var.bastion_sg_id]
  }

  ingress {
    description     = "EC2 Bastion se Grafana UI"
    from_port       = 3000
    to_port         = 3000
    protocol        = "tcp"
    security_groups = [var.bastion_sg_id]
  }

  ingress {
    description     = "EC2 Bastion se Alertmanager UI"
    from_port       = 9093
    to_port         = 9093
    protocol        = "tcp"
    security_groups = [var.bastion_sg_id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
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

ingress {
  description     = "Redis exporter to Redis"
  from_port       = 6379
  to_port         = 6379
  protocol        = "tcp"
  self            = true
}
    # Allow from ALB on port 7070 (cart)
    ingress {
        description= "Allow traffic from ALB on port 7070"
        security_groups = [aws_security_group.alb_sg.id]
        from_port= 7070
        to_port = 7070
        protocol= "tcp"
    }

    ingress {
        description = "Allow traffic from ALB on port 3550"
        security_groups = [aws_security_group.alb_sg.id]
        from_port= 3550
        to_port = 3550
        protocol = "tcp"
    }

     ingress {
    description     = "Prometheus scraping"
    from_port       = 8080
    to_port         = 8080
    protocol        = "tcp"
    security_groups = [aws_security_group.prom_sg.id]
     }  

    ingress {
        description = "Allow ECS tasks to communicate with each other"
        self = true
        from_port= 0
        to_port= 65535
        protocol= "tcp"
    }
 ingress {
        description = "redis scrapping by prom"
        from_port= 9121
        to_port= 9121
        protocol= "tcp"
        security_groups = [aws_security_group.prom_sg.id]

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
    description     = "Prometheus UI from private ALB"
    from_port       = 9090
    to_port         = 9090
    protocol        = "tcp"
    security_groups = [aws_security_group.prom_alb_sg.id]
  }

ingress {
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    security_groups =[aws_security_group.prom_alb_sg.id]
  }

  ingress {
    from_port   = 9093
    to_port     = 9093
    protocol    = "tcp"
    security_groups = [aws_security_group.prom_alb_sg.id]
  }

  ingress {
    description     = "EC2 SSM Bastion access"
    from_port       = 0
    to_port         = 65535
    protocol        = "tcp"
    security_groups = [var.bastion_sg_id]
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
  security_groups = [aws_security_group.prom_alb_sg.id]
  from_port  = 9093
  to_port  = 9093
  protocol = "tcp"
}

 ingress {
    description     = "Prometheus se alerts"
    from_port       = 9093
    to_port         = 9093
    protocol        = "tcp"
    security_groups = [aws_security_group.prom_sg.id]
  }


    egress {
        from_port= 0
        to_port = 0
        protocol = "-1"
        cidr_blocks  = ["0.0.0.0/0"]
    }
}

resource "aws_security_group" "grafna_sg" {
      name = "grafna-sg"
      vpc_id = var.vpc_id
      tags = {
        Name ="grafna-sg"
      }
  
  ingress {
      description = "allow Traffic from Promotheus"
      security_groups = [aws_security_group.prom_alb_sg.id]
      from_port = 3000
      to_port = 3000
      protocol = "tcp"
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

}