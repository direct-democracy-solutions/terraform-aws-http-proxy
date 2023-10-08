resource "aws_default_vpc" "vpc" {}

data "aws_availability_zones" "available" {
  state = "available"
}

resource "aws_route_table" "private" {
  vpc_id = aws_default_vpc.vpc.id
  route = []
}

resource "aws_subnet" "subnet" {
  for_each = { for i, name in data.aws_availability_zones.available.names: i => name }
  vpc_id = aws_default_vpc.vpc.id
  availability_zone = each.value
  cidr_block = cidrsubnet(aws_default_vpc.vpc.cidr_block, 4, 8 + each.key)
  map_public_ip_on_launch = false
}

resource "aws_route_table_association" "private" {
  for_each = aws_subnet.subnet
  subnet_id = each.value.id
  route_table_id = aws_route_table.private.id
}

resource "aws_apigatewayv2_vpc_link" "target" {
  name = "test-vpc-link"
  security_group_ids = [ aws_security_group.vpc_link.id ]
  subnet_ids = [ for s in aws_subnet.subnet : s.id ]
}

resource "aws_security_group" "vpc_link" {
  name = "test-vpc-link"
  vpc_id = aws_default_vpc.vpc.id
}

resource "aws_vpc_security_group_egress_rule" "vpc_link_to_load_balancer" {
  security_group_id = aws_security_group.vpc_link.id
  ip_protocol = "tcp"
  from_port = 80
  to_port = 80
  referenced_security_group_id = aws_security_group.target.id
}

resource "aws_vpc_security_group_ingress_rule" "vpc_link_from_internet" {
  security_group_id = aws_security_group.vpc_link.id
  ip_protocol = "tcp"
  from_port = 80
  to_port = 80
  cidr_ipv4 = "0.0.0.0/0"
}
