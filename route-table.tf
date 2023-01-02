# public 2a subnet route
resource "aws_route" "public-2a-igw" {
  route_table_id = aws_route_table.public_2a.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.main.id
}

# public 2c subnet route
resource "aws_route" "public-2c-igw" {
  route_table_id = aws_route_table.public_2c.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.main.id
}

# private 2a subnet route
resource "aws_route" "private-2a-igw" {
  route_table_id = aws_route_table.private_2a.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id = aws_nat_gateway.natgw.id
}

# private 2c subnet route
resource "aws_route" "private-2c-igw" {
  route_table_id = aws_route_table.private_2c.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id = aws_nat_gateway.natgw.id
}