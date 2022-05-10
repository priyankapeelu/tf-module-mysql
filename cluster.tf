resource "aws_security_group" "allow_mysql" {
  name        = "roboshop-mysql-${var.ENV}"
  description = "roboshop-mysql-${var.ENV}"
  vpc_id      = data.terraform_remote_state.vpc.outputs.VPC_ID

  ingress {
    description = "TLS from VPC"
    from_port   = var.RDS_MYSQL_PORT
    to_port     = var.RDS_MYSQL_PORT
    protocol    = "tcp"
    cidr_blocks = [data.terraform_remote_state.vpc.outputs.VPC_CIDR, var.WORKSTATION_IP]
  }
  ingress {
    description = "open to public"
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "roboshop-redis-${var.ENV}"
  }
}

resource "aws_db_instance" "mysql" {
  identifier             = "roboshop-mysql-${var.ENV}"
  allocated_storage      = var.RDS_MYSQL_PORT
  engine                 = "mysql"
  engine_version         = var.RDS_MYSQL_PORT
  instance_class         = var.RDS_MYSQL_PORT
  username               = "admin1"
  password               = "RoboShop1"
  parameter_group_name   = aws_db_parameter_group.mysql.name
  skip_final_snapshot    = true
  db_subnet_group_name   = aws_db_subnet_group.mysql.name
  vpc_security_group_ids = [aws_security_group.allow_mysql.id]
}


resource "aws_db_parameter_group" "mysql" {
  name   = "roboshop-${var.ENV}"
  family = "mysql${var.RDS_ENGINE_VERSION}"
}

resource "aws_db_subnet_group" "mysql" {
  name       = "roboshop-mysql-${var.ENV}"
  subnet_ids = data.terraform_remote_state.vpc.outputs.PRIVATE_SUBNET_IDS

  tags = {
    Name = "roboshop-${var.ENV}"
  }
}
