# Subnet group
resource "aws_db_subnet_group" "this" {
  name       = "${var.name}-subnet-group"
  subnet_ids = var.subnet_ids

  tags = {
    Name = "${var.name}-db-subnet-group"
  }
}

# RDS instance
resource "aws_db_instance" "this" {
  identifier           = "${var.name}-instance"
  allocated_storage    = var.allocated_storage
  engine               = "postgres"
  engine_version       = "15.15"
  instance_class       = var.instance_class

  # Default database inside RDS
  db_name                 = var.db_name
  username             = var.username
  password             = var.password

  db_subnet_group_name = aws_db_subnet_group.this.name
  vpc_security_group_ids = var.vpc_security_group_ids

  skip_final_snapshot  = true
  publicly_accessible  = var.publicly_accessible
  multi_az             = false
  tags = {
    Name = "${var.name}-rds"
  }
}


