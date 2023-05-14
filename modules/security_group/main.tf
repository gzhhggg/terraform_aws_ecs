resource "aws_security_group" "default" {
  name = "${var.name}-sg"
  description = "${var.name}-sg"
  vpc_id = var.vpc_id
  tags = {
    Name = "${var.name}-sg"
  }
}

resource "aws_security_group_rule" "default" {
  security_group_id = aws_security_group.default.id
  type = "egress"
  from_port = 0
  to_port = 0
  protocol = "-1"
  cidr_blocks = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "inbound" {
  for_each = toset(var.inbound_ports)

  security_group_id = aws_security_group.default.id
  type = "ingress"
  from_port = each.value
  to_port = each.value
  protocol = "tcp"
  cidr_blocks = var.inbound_cidr_blocks
  source_security_group_id = var.inbound_source_security_group_id
}