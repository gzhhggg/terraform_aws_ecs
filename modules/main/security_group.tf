module "sg_public" {
  source = "../security_group"

  name = "public"
  name_prefix = var.project

  vpc_id = aws_vpc.default.id
  inbound_ports = [
    "443",
    "80",
    "22",
  ]
  inbound_cidr_blocks = ["0.0.0.0/0"]
}

module "sg_private" {
  source = "../security_group"

  name = "private"
  name_prefix = var.project

  vpc_id = aws_vpc.default.id
  inbound_ports = [
    "3306",
  ]
  inbound_source_security_group_id = module.sg_public.security_group_id
}

module "sg_ecs" {
  source = "../security_group"

  name = "ecs"
  name_prefix = var.project

  vpc_id = aws_vpc.default.id
  inbound_ports = [
    "8080",
  ]
  inbound_source_security_group_id = module.sg_public.security_group_id
}

# module "sg_vpc_endpoint" {
#   source = "./security_group"

#   name = "vpce"
#   name_prefix = var.project

#   vpc_id = var.aws_vpc.id
#   inbound_ports = [
#     "3306",
#   ]
#   inbound_source_security_group_id = module.sg_public.security_group_id
# }