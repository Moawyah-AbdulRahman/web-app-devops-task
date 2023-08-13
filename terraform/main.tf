resource "aws_key_pair" "webapp_access" {
    key_name = "webapp_access"
    public_key = file("~/.ssh/id_rsa.pub")
    
}

resource "aws_security_group" "backend" {
  name_prefix = "backend-"
  
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.allow_ssh_access_from
  }

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["${aws_instance.frontend_instance.private_ip}/32"]
  }

  ingress {
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["${aws_instance.frontend_instance.private_ip}/32"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all outbound traffic"
  }
}

resource "aws_instance" "db_instance" {
  ami           = "ami-01dd271720c1ba44f"
  instance_type = var.db_instance_type
  key_name    = aws_key_pair.webapp_access.key_name

  security_groups = [aws_security_group.backend.name]

  tags = {
    Name = "db-postgres-01"
    env  = "test"
  }
}


resource "aws_security_group" "frontend" {
  name_prefix = "frontend-"
  ingress {
    
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.allow_ssh_access_from
  
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all outbound traffic"
  }

}

resource "aws_instance" "frontend_instance" {
  ami           = "ami-01dd271720c1ba44f"
  instance_type = var.frontend_instance_type
  key_name    = aws_key_pair.webapp_access.key_name

  security_groups = [aws_security_group.frontend.name]

  tags = {
    Name = "app-01"
    env  = "test"
  }
}

