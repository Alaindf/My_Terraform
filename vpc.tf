resource "aws_vpc" "main" {
  cidr_block = var.vpc_cdir
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "main_igw"
  }
}

resource "aws_route_table" "pub" {
  vpc_id = aws_vpc.main.id

  route {
    ipv6_cidr_block = "::/0"
    gateway_id      = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "pub_rt"
  }
}

resource "aws_route_table" "priv" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "priv_rt"
  }
}

resource "aws_subnet" "pub_sub1" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.pub_cidr
  map_public_ip_on_launch = true
  tags = {
    Name = "pub_sub1"
  }
}

resource "aws_subnet" "pub_sub2" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.pub2_cidr
  map_public_ip_on_launch = true
  tags = {
    Name = "pub_sub2"
  }
}

resource "aws_subnet" "priv_sub" {
  vpc_id     = aws_vpc.main.id
  cidr_block = var.priv_cidr

  tags = {
    Name = "priv_sub"
  }
}

resource "aws_route_table_association" "a_pub_rt1" {
  subnet_id      = aws_subnet.pub_sub1.id
  route_table_id = aws_route_table.pub.id
}

resource "aws_route_table_association" "a_pub_rt2" {
  subnet_id      = aws_subnet.pub_sub2.id
  route_table_id = aws_route_table.pub.id
}

resource "aws_route_table_association" "b_priv_rt" {
  subnet_id      = aws_subnet.priv_sub.id
  route_table_id = aws_route_table.priv.id
}
