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