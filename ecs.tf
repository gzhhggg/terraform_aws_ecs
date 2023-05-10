
resource "aws_ecs_cluster" "default" {
  name = "hello-world-ecs-cluster"
}

resource "aws_ecs_task_definition" "default" {
  family = "hello-world-ecs-task-definition"
  network_mode = "awsvpc"
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  cpu = 256
  memory = 512
  requires_compatibilities = [ "FARGATE" ]
  container_definitions = jsonencode([
    {
      name      = "hello-world-ecs-test-nginx"
      image     = "166382810986.dkr.ecr.ap-northeast-1.amazonaws.com/hello-world-ecs-test"
      essential = true
      cpu = 256
      memory = 512
      portMappings = [
        {
          containerPort = 80
          hostPort      = 80
        }
      ]
    }
  ])
}

resource "aws_iam_role" "ecs_task_execution_role" {
  name = "ecs-task-execution-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_policy" "ecr_policy" {
  name_prefix = "ecr-policy"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "ecr:GetAuthorizationToken",
          "ecr:BatchCheckLayerAvailability",
          "ecr:GetDownloadUrlForLayer",
          "ecr:GetRepositoryPolicy",
          "ecr:DescribeRepositories",
          "ecr:ListImages",
          "ecr:DescribeImages",
          "ecr:BatchGetImage"
        ]
        Effect = "Allow"
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ecs_task_execution_role_attachment" {
  policy_arn = aws_iam_policy.ecr_policy.arn
  role       = aws_iam_role.ecs_task_execution_role.name
}

resource "aws_ecs_service" "default" {
  name = "hello-world-ecs-test-service2"
  cluster = aws_ecs_cluster.default.id
  task_definition = aws_ecs_task_definition.default.arn
  desired_count = 1
  launch_type = "FARGATE"
    network_configuration {
    security_groups = [aws_security_group.public.id]
    subnets         = [aws_subnet.public.id]
    assign_public_ip = true
  }
}