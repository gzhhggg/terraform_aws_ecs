output "subnet" {
  value = aws_subnet.default
}

output "route_table_id" {
  value = aws_route_table.default.id
}