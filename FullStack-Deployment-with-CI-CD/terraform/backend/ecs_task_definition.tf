resource "aws_ecs_task_definition" "service" {
  family                   = "testTaskDefinition"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = "1024"
  memory                   = "2048"
  execution_role_arn       = data.aws_iam_role.ecs_execution_role.arn

  runtime_platform {
    cpu_architecture        = "X86_64"
    operating_system_family = "LINUX"
  }

  container_definitions = jsonencode([
    {
      name      = "testTaskDefinition"
      image     = "${aws_ecr_repository.ecr-1.repository_url}:latest"
      cpu       = 1024
      memory    = 2048
      essential = true

      portMappings = [
        {
          containerPort = tonumber(var.app_port)
          hostPort      = tonumber(var.app_port)
        }
      ],
      environment = [
        {
          name  = "PORT"
          value = var.app_port
        },
        {
          name  = "DB_URL"
          value = var.db_url
        }
      ],
      healthCheck = {
        command = ["CMD-SHELL", "curl -f http://localhost:5000/health || exit 1"]
      }
    }
  ])
}
