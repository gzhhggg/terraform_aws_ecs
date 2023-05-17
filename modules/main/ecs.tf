resource "aws_ecs_cluster" "default" {
  name = "myapp-cluster"
}

resource "aws_ecs_task_definition" "default" {
  family = "myapp-task-definition"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  memory = 512
  cpu    = 256
  task_role_arn = aws_iam_role.ecs_task_role.arn
  execution_role_arn = aws_iam_role.ecs_task_execution_role.arn
  container_definitions    = jsonencode(
    [
      {
        name      = "myapp"
        image     = "166382810986.dkr.ecr.ap-northeast-1.amazonaws.com/myapp:v1"
        portMappings = [
          {
            containerPort = 8080
            protocol      = "tcp"
          },
        ],
        "logConfiguration": {
          "logDriver": "awslogs",
          "options": {
            "awslogs-group": "${aws_cloudwatch_log_group.default.name}",
            "awslogs-region": "ap-northeast-1",
            "awslogs-stream-prefix": "ecs"
          }
        },
        "environment": [
        {
          "name": "MYSQL_HOST",
          "value": "${aws_ssm_parameter.default.value}"
        }
    ],
      },
    ]
  )
}

data "aws_iam_policy_document" "ecs_assume_role" {
  statement {
  actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "ecs_task" {
  statement {
    effect = "Allow"
    actions = [
      "rds:*",
      "logs:DescribeLogStreams",
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
      "xray:*",
      "ssm:DescribeParameters",
      "ssm:GetParameter*"
    ]
    resources = [
      "*"
    ]
  }
}

resource "aws_iam_role" "ecs_task_role" {
  name = "${var.project}-ecs-task-role"
  assume_role_policy = data.aws_iam_policy_document.ecs_assume_role.json
}

resource "aws_iam_policy" "ecs_task_policy" {
  name = "${var.project}-ecs-task-policy"
  policy = data.aws_iam_policy_document.ecs_task.json
}

resource "aws_iam_role" "ecs_task_execution_role" {
  name = "${var.project}-ecs-task-exec-role"
  assume_role_policy = data.aws_iam_policy_document.ecs_assume_role.json
}

resource "aws_iam_role_policy_attachment" "ecs_task_execution_role_policy" {
  role = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_iam_role_policy_attachment" "ecs_task_role_policy" {
  role = aws_iam_role.ecs_task_role.name
  policy_arn = aws_iam_policy.ecs_task_policy.arn
}

resource "aws_ecs_service" "default" {
  name = "${var.project}-ecs-service"
  cluster = aws_ecs_cluster.default.id
  task_definition = aws_ecs_task_definition.default.id
  desired_count = 1
  launch_type = "FARGATE"
  platform_version = "1.4.0"
  load_balancer {
      target_group_arn = aws_lb_target_group.default.arn
      container_name = "myapp"
      container_port = 8080
    }
  network_configuration {
    subnets = [ for subnet in module.network_public.subnets : subnet.id ]
    security_groups = [ module.sg_ecs.security_group_id ]
    assign_public_ip = true
  }
}