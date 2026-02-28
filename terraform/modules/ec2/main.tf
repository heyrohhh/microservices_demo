resource "aws_instance" "ssm_bastion" {
  ami = "ami-0f3caa1cf4417e51b"
  instance_type = "t3.micro"              
  subnet_id= var.private_subnet_ids[0]
  vpc_security_group_ids= [aws_security_group.ssm_bastion_sg.id]
  associate_public_ip_address = false
  iam_instance_profile= aws_iam_instance_profile.ssm_profile.name

  tags = {
    Name = "ssm-bastion"
  }
}

resource "aws_security_group" "ssm_bastion_sg" {
  name= "ssm-bastion-sg"
  vpc_id = var.vpc_id                               

  egress {
    from_port= 0                            
    to_port= 0
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "ssm-bastion-sg"
  }
}

resource "aws_iam_role" "ssm_role" {
  name = "ssm-ec2-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = { Service = "ec2.amazonaws.com" }
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "ssm_policy" {
  role  = aws_iam_role.ssm_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_instance_profile" "ssm_profile" {
  name = "ssm-ec2-profile"
  role = aws_iam_role.ssm_role.name
}