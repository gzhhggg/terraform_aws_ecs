resource "aws_lb" "default" {
  name = "${var.project}-lb"
  internal = false
  load_balancer_type = "application"
  idle_timeout = 60
  security_groups = [module.sg_public.security_group_id]
  subnets = [for subnet in module.network_public.subnets : subnet.id ]
}

resource "aws_lb_listener" "default" {
  load_balancer_arn = aws_lb.default.arn
  port = 80
  protocol = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.default.arn
  }
}

resource "aws_lb_target_group" "default" {
  name = "${var.project}-lb-target"
  target_type = "ip"
  vpc_id = aws_vpc.default.id
  port = 80
  protocol = "HTTP"
}
