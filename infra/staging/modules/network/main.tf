resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = var.tags
}

resource "aws_subnet" "public" {
  for_each          = { for sb in var.public_subnets : sb.name => sb }
  vpc_id            = aws_vpc.main.id
  cidr_block        = each.value.cidr
  availability_zone = each.value.az

  tags = merge(var.tags, { "Name" : "${var.prefix}-${each.value.name}" })
}

resource "aws_subnet" "private" {
  for_each          = { for sb in var.private_subnets : sb.name => sb }
  vpc_id            = aws_vpc.main.id
  cidr_block        = each.value.cidr
  availability_zone = each.value.az

  tags = merge(var.tags, { "Name" : "${var.prefix}-${each.value.name}" })
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id
  tags   = merge({ "Name" = "${var.prefix}-ig" }, var.tags)
}
# VPC RouteTable
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id
  tags   = merge({ "Name" : "${var.prefix}-route-public" }, var.tags)
}

# パブリックサブネット用ルートテーブル
resource "aws_route" "public" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.main.id
}

# プライベートサブネット用ルートテーブル
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id
  tags   = merge({ "Name" : "${var.prefix}--route-private" }, var.tags)
}


resource "aws_route_table_association" "public" {
  for_each       = { for sb in var.public_subnets : sb.name => sb }
  subnet_id      = aws_subnet.public[each.key].id
  route_table_id = aws_route_table.public.id
}

# RouteTableAssociation for pribate
resource "aws_route_table_association" "private" {
  for_each       = { for sb in var.private_subnets : sb.name => sb }
  subnet_id      = aws_subnet.private[each.key].id
  route_table_id = aws_route_table.private.id
}
