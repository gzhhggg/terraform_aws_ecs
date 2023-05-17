locals {
  rds_endpoint = split(":", aws_db_instance.default.endpoint)[0]
}

resource "aws_ssm_parameter" "default" {
  name = "${var.project}-rds-endpoint"
  description = "${var.project}-rds-endpoint"
  value = local.rds_endpoint
  type = "SecureString"
  overwrite = true
}