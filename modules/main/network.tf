# VPCの作成
resource "aws_vpc" "default" {
  cidr_block       = var.vpc_id
  instance_tenancy = "default"
  tags = {
    Name = var.vpc_name
  }
}

# インターネットゲートウェイ作成
resource "aws_internet_gateway" "default" {
  vpc_id = aws_vpc.default.id
  tags = {
    Name = "internet-gateway"
  }
}

module "network_public" {
  source = "../network"

  name = "public"
  vpc_id = aws_vpc.default.id
  subnet = var.subnet.public
  internet_gateway_id = aws_internet_gateway.default.id
}

module "network_private" {
  source = "../network"

  name = "private"
  vpc_id = aws_vpc.default.id
  subnet = var.subnet.private
}

