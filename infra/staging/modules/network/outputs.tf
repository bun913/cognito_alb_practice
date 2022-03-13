output "public_subnet_ids" {
  value = [
    for sb in aws_subnet.public : sb.id
  ]
}

output "private_subnet_ids" {
  value = [
    for sb in aws_subnet.private : sb.id
  ]
}

output "vpc_id" {
  value = aws_vpc.main.id
}

output "private_route_table_id" {
  value = aws_route_table.private.id
}
