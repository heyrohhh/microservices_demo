
#ecs cluster

resource "aws_ecs_cluster" "ecs_cluster" {
   name = "white-hart"
  setting {
    name  = "containerInsights"
    value = "enabled"
  }
}

resource "aws_iam_role" "task_execution_role" {
  name = "task-execution"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      },
    ]
  })

  tags = {
    tag-key = "task-execution"
  }
}

resource "aws_iam_role_policy_attachment" "ecs_execution_policy" {
  role      = aws_iam_role.task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_iam_role" "task_role" {
  name ="task-role"
 assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect    = "Allow"
        Action    = "sts:AssumeRole"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      }
    ]
  })

  tags = {
    tag-key = "task-role"
  }
}

resource "aws_iam_role_policy" "task_role_secrets" {
  name = "task-role-secrets-policy"
  role = aws_iam_role.task_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = ["secretsmanager:GetSecretValue"]
        Resource = "arn:aws:secretsmanager:us-east-1:985017008178:secret:TELEGRAM_BOT_TOKEN-BTvHit"
      }
    ]
  })
}
resource "aws_iam_role_policy" "execution_role_secrets" {
  name = "execution-role-secrets-policy"
  role = aws_iam_role.task_execution_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = ["secretsmanager:GetSecretValue"]
       Resource = [
          "arn:aws:secretsmanager:us-east-1:985017008178:secret:GF_SECURITY_ADMIN_USER-xMu4ly",
          "arn:aws:secretsmanager:us-east-1:985017008178:secret:GF_SECURITY_ADMIN_PASSWORD-Rwxzvg"
        ]
      }
    ]
  })
} 