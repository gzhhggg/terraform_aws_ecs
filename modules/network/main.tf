resource "aws_subnet" "default" {
  for_each = var.subnet
  vpc_id            = var.vpc_id
  cidr_block        = each.value
  availability_zone = "${data.aws_region.current.name}${each.key}"
  tags = {
    Name = "${var.name}-${each.key}"
  }
}

resource "aws_route_table" "default" {
  vpc_id = var.vpc_id

  dynamic "route" {
    for_each = var.internet_gateway_id != null ? [1] : []
    content {
      cidr_block = "0.0.0.0/0"
      gateway_id = var.internet_gateway_id
    }
  }

  tags = {
    Name = "${var.name}-${"rt"}"
  }
}

resource "aws_route_table_association" "default" {
  for_each = aws_subnet.default

  subnet_id      = each.value.id
  route_table_id = aws_route_table.default.id
}