# Define parameter group
resource "aws_db_parameter_group" "rds_param_group" {
  name        = var.db_param_group_name
  family      = var.db_param_group_family
  description = var.db_param_group_description

  tags = {
    name = var.db_param_group_name
  }
}

resource "aws_db_subnet_group" "db_subnet_group" {
  name        = var.db_subnet_group_name
  description = var.db_subnet_group_name
  subnet_ids  = var.db_subnet_ids

  tags = {
    name = var.db_subnet_group_name
  }
}

resource "aws_db_instance" "rds_instance" {
  identifier           = var.db_identifier
  instance_class       = var.db_instance_class
  multi_az             = var.db_multi_az
  engine               = var.db_engine
  engine_version       = var.db_engine_version
  db_name              = var.db_name
  username             = var.db_username
  password             = var.db_password
  parameter_group_name = aws_db_parameter_group.rds_param_group.name
  publicly_accessible  = var.db_publicly_accessible
  skip_final_snapshot  = var.db_skip_final_snapshot
  deletion_protection  = var.db_deletion_protection
  allocated_storage    = var.db_allocated_storage
  port                 = var.db_port
  storage_encrypted    = true

  vpc_security_group_ids = var.db_vpc_security_group_ids
  db_subnet_group_name   = aws_db_subnet_group.db_subnet_group.name
  kms_key_id             = var.kms_key_id

  tags = {
    name = var.db_identifier
  }
}