resource "aws_ecs_task_definition" "greengrass-core-task" {
  family                = "greengrass-core-task"
  container_definitions = file("./greengrassCoreContainer.json")
  network_mode          = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = 1024
  memory                   = 2048
  execution_role_arn       = "arn:aws:iam::199982716068:role/ecsTaskExecutionRole"

  volume {
    name    = "certs"
    efs_volume_configuration {
      file_system_id = aws_efs_file_system.greengrassCoreFS.id
      root_directory = "/greengrass/certs"
    }
  }
    volume {
    name    = "logs"
    efs_volume_configuration {
      file_system_id = aws_efs_file_system.greengrassCoreFS.id
      root_directory = "/greengrass/logs"
    }
  }
    volume {
    name    = "config"
    efs_volume_configuration {
      file_system_id = aws_efs_file_system.greengrassCoreFS.id
      root_directory = "/greengrass/config"
    }
  }
  
  depends_on = [aws_efs_file_system.greengrassCoreFS]
}

resource "aws_ecs_service" "greengrass-core-service" {
  name            = "greengrass-core-service"
  cluster         = aws_ecs_cluster.iot_cluster.id
  task_definition = aws_ecs_task_definition.greengrass-core-task.arn
  launch_type     = "FARGATE"
  platform_version = "1.4.0"
  network_configuration {
    security_groups = [aws_security_group.greengrass_core_security_group.id]
    subnets         = [aws_subnet.public.id]
  }
}

resource "aws_cloudwatch_log_group" "fargate_task_definition" {
  name = "/ecs/fargate-task-definition"
}

resource "aws_security_group" "greengrass_core_security_group" {
  name        = "greengrass_core_security_group"
  description = "Allow MQQT and EFS"
  vpc_id      = aws_vpc.main.id

    ingress {
        description = "MQQT"
        from_port   = 8883
        to_port     = 8883
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
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