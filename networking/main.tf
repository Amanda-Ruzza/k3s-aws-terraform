# ----- networking/main.tf ---- 

# Declaring the data source for the AWS AZ's
data "aws_availability_zones" "available" {}

# Generating a random number as a sufix after each VPC's name - this works for multiple resource deployments
resource "random_integer" "random" {
  min = 1
  max = 100
}

resource "random_shuffle" "az_list" {
  input        = data.aws_availability_zones.available.names
  result_count = var.max_subnets
}

resource "aws_vpc" "k3s_vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true
  #instance_tenancy = "default"

  tags = {
    Name = "k3s_vpc-${random_integer.random.id}"
  }
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_subnet" "k3s_public_subnet" {
  count                   = var.public_sn_count
  vpc_id                  = aws_vpc.k3s_vpc.id
  cidr_block              = var.public_cidrs[count.index]
  map_public_ip_on_launch = true #This works for public subnets. In private subnets if defaults to 'false'
  availability_zone       = random_shuffle.az_list.result[count.index]

  tags = {
    Name = "k3s_public_${count.index + 1}"
  }
}

# Using a Route Table Association to connect the RT with the Subnet

resource "aws_route_table_association" "k3s_public_association" {
  count          = var.public_sn_count
  subnet_id      = aws_subnet.k3s_public_subnet.*.id[count.index]
  route_table_id = aws_route_table.k3s_public_rt.id
}

resource "aws_subnet" "k3s_private_subnet" {
  count                   = var.private_sn_count
  vpc_id                  = aws_vpc.k3s_vpc.id
  cidr_block              = var.private_cidrs[count.index]
  map_public_ip_on_launch = false
  availability_zone       = random_shuffle.az_list.result[count.index]

  tags = {
    Name = "k3s_private_${count.index + 1}"
  }
}

resource "aws_internet_gateway" "k3s_internet_gateway" {
  vpc_id = aws_vpc.k3s_vpc.id

  tags = {
    Name = "k3s_igw"
  }
}

resource "aws_route_table" "k3s_public_rt" {
  vpc_id = aws_vpc.k3s_vpc.id

  tags = {
    Name = "k3s_public_rt"
  }
}

# Using the IGW as the default route
resource "aws_route" "default_route" {
  route_table_id         = aws_route_table.k3s_public_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.k3s_internet_gateway.id
}

# Using the Private Route Table as a default RT
resource "aws_default_route_table" "k3s_private_rt" {
  default_route_table_id = aws_vpc.k3s_vpc.default_route_table_id

  tags = {
    Name = "k3s_private_rt"
  }
}

resource "aws_security_group" "k3s_public_sg" {
  for_each    = var.security_groups
  name        = each.value.name
  description = each.value.description
  vpc_id      = aws_vpc.k3s_vpc.id
  #public Security Group
  dynamic "ingress" {
    for_each = each.value.ingress
    content {
      from_port   = ingress.value.from
      to_port     = ingress.value.to
      protocol    = ingress.value.protocol
      cidr_blocks = ingress.value.cidr_blocks
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_db_subnet_group" "k3s_rds_subnetgroup" {
  count      = var.db_subnet_group == true ? 1 : 0
  name       = "k3s_rds_subnetgroup"
  subnet_ids = aws_subnet.k3s_private_subnet.*.id #The '*' means that any private subnets created can be used by this 'Subnet Group'
  tags = {
    "Name" = "k3s_rds_sng"
  }
}
