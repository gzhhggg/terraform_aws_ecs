resource "aws_db_subnet_group" "default" {
  name        = "${var.project}-${"rds"}"
  description = "${var.project}-${"rds"}"
  subnet_ids  = [for subnet in module.network_private.subnets : subnet.id]
}

resource "aws_db_instance" "default" {
  identifier              = "${var.project}-mysql"
  engine                  = "mysql"
  engine_version          = "8.0.31"
  instance_class          = "db.t2.micro"
  allocated_storage       = 20
  storage_type            = "gp2"
  vpc_security_group_ids  = [module.sg_private.security_group_id]
  db_subnet_group_name    = aws_db_subnet_group.default.name
  username                = "myuser"
  password                = "mypassword"
  skip_final_snapshot    = true
}