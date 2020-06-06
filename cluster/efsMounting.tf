resource "aws_efs_file_system" "greengrassCoreFS" {
  creation_token = "greengrassCoreFS"

  tags = {
    Name = "greengrassCoreFS"
  }
}

resource "aws_efs_mount_target" "alpha" {
  file_system_id = aws_efs_file_system.greengrassCoreFS.id
  subnet_id      = aws_subnet.public.id
  security_groups = [aws_security_group.efs_mount_target_security_group.id]
}

resource "aws_security_group" "efs_mount_target_security_group" {
  name        = "efs_mount_target_security_group"
  description = "Allow EFS"
  vpc_id      = aws_vpc.main.id

    ingress {
        description = "EFS"
        from_port   = 2049
        to_port     = 2049
        protocol    = "tcp"
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