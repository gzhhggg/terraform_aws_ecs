
# VPCの作成
resource "aws_vpc" "default" {
  cidr_block       = local.vpc_id
  instance_tenancy = "default"
  tags = {
    Name = local.vpc_name
  }
}

# パブリックサブネットの作成
resource "aws_subnet" "public" {
  vpc_id            = aws_vpc.default.id
  cidr_block        = local.subnet.public["a"]
  availability_zone = "${data.aws_region.current.name}${"a"}"
  tags = {
    "Name" = "public-subnet-${"a"}"
  }
}

# インターネットゲートウェイ作成
resource "aws_internet_gateway" "default" {
  vpc_id = aws_vpc.default.id
  tags = {
    Name = "internet-gateway"
  }
}

# ルーティング
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.default.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.default.id
  }
  tags = {
    Name = "public-rt"
  }
}

resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}