resource "aws_cloudwatch_log_group" "default" {
  name = "${var.project}/ecs/myapp"
}