data "aws_availability_zones" "available" { state = "available" }

locals {
  azs_count = 2
  azs_names = data.aws_availability_zones.available.names
}

resource "aws_vpc" "main" {
  cidr_block           = "10.10.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags                 = { Name = "vpc" }
}

### PUBLIC CONFIGURATION

resource "aws_subnet" "public" {
  count                   = local.azs_count
  vpc_id                  = aws_vpc.main.id
  availability_zone       = local.azs_names[count.index]
  cidr_block              = cidrsubnet(aws_vpc.main.cidr_block, 8, 10 + count.index)
  map_public_ip_on_launch = true
  tags                    = { Name = "public-${local.azs_names[count.index]}" }
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id
  tags   = { Name = "igw" }

  timeouts {
    delete = "2m"
  }
}

resource "aws_eip" "main" {
  count      = local.azs_count
  depends_on = [aws_internet_gateway.main]
  tags       = { Name = "eip-${local.azs_names[count.index]}" }

  vpc = true
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id
  tags   = { Name = "rt-public" }

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }
}

resource "aws_route_table_association" "public" {
  count = local.azs_count

  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

resource "aws_nat_gateway" "public" {
  count = local.azs_count

  allocation_id = aws_eip.main[count.index].allocation_id
  subnet_id     = aws_subnet.public[count.index].id
}


### PRIVATE CONFIGURATION
resource "aws_subnet" "private" {
  count             = local.azs_count
  vpc_id            = aws_vpc.main.id
  availability_zone = local.azs_names[count.index]
  cidr_block        = cidrsubnet(aws_vpc.main.cidr_block, 8, 16 + count.index)
  tags              = { Name = "private-${local.azs_names[count.index]}" }
}

resource "aws_ec2_transit_gateway" "transit_gateway" {}

resource "aws_ec2_transit_gateway_vpc_attachment" "gateway_attachement" {
  subnet_ids = aws_subnet.private[*].id

  vpc_id             = aws_vpc.main.id
  transit_gateway_id = aws_ec2_transit_gateway.transit_gateway.id
}

resource "aws_route_table" "private" {
  count = local.azs_count

  vpc_id = aws_vpc.main.id
}

resource "aws_route" "private" {
  count = local.azs_count

  route_table_id = aws_route_table.private[count.index].id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id = aws_nat_gateway.public[count.index].id
}

resource "aws_route_table_association" "private" {
  count = local.azs_count

  route_table_id = aws_route_table.private[count.index].id
  subnet_id      = aws_subnet.private[count.index].id
}
