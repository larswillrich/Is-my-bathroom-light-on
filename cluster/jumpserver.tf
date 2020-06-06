resource "aws_ecs_task_definition" "jump_sever_task" {
  family                = "jump_sever_task"
  container_definitions = file("./jumpserver.json")
  network_mode          = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = 1024
  memory                   = 2048
  execution_role_arn       = "arn:aws:iam::199982716068:role/ecsTaskExecutionRole"

  volume {
    name    = "greengrass"
    efs_volume_configuration {
      file_system_id = aws_efs_file_system.greengrassCoreFS.id
      root_directory = "/"
    }
  }

  depends_on = [aws_efs_file_system.greengrassCoreFS]
}

resource "aws_ecs_service" "jump_ssh_service" {
  name            = "jump_ssh_service"
  cluster         = aws_ecs_cluster.iot_cluster.id
  task_definition = aws_ecs_task_definition.jump_sever_task.arn
  launch_type     = "FARGATE"
  platform_version = "1.4.0"
  network_configuration {
    security_groups = [aws_security_group.jump_server_security_group.id]
    subnets         = [aws_subnet.public.id]
  }
}

resource "aws_security_group" "jump_server_security_group" {
  name        = "jump_server_security_group"
  description = "Allow SSH, EFS and ping"
  vpc_id      = aws_vpc.main.id

    ingress {
        description = "EFS"
        from_port   = 2049
        to_port     = 2049
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        description = "SSH"
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        from_port = 8
        to_port = 0
        protocol = "icmp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

  tags = {
    Name = "provisioned with terraform"
  }
}