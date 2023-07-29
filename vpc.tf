# Create VPC
resource "aws_vpc" "daps" {
  cidr_block = var.vpc-cidr 
  instance_tenancy = var.tenancy
  tags = {
    Name = "${var.env_prefix}-Daps-vpc"
  }
}

# Create internet gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.daps.id

  tags = {
    Name = "daps-igw"
  }
}


# Create subnets
resource "aws_subnet" "public-subnet-1" {
  vpc_id     = aws_vpc.daps.id
  cidr_block = var.pub-sub-cidr[0]
  availability_zone = var.avail-zone[0]

  tags = {
    Name = "${var.env_prefix}-Daps-pub-sub-1"
  }
}

resource "aws_subnet" "public-subnet-2" {
  vpc_id     = aws_vpc.daps.id
  cidr_block = var.pub-sub-cidr[1]
  availability_zone = var.avail-zone[1]

  tags = {
    Name = "${var.env_prefix}-Daps-pub-sub-2"
  }
}

resource "aws_subnet" "private-subnet-1" {
  vpc_id     = aws_vpc.daps.id
  cidr_block = var.private-sub-cidr[0]
  availability_zone = var.avail-zone[0]

  tags = {
    Name = "${var.env_prefix}-Daps-private-sub-1"
  }
}

resource "aws_subnet" "private-subnet-2" {
  vpc_id     = aws_vpc.daps.id
  cidr_block = var.private-sub-cidr[1]
  availability_zone = var.avail-zone[1]

  tags = {
    Name = "${var.env_prefix}-Daps-private-sub-2"
  }
}

# create public route table and associate 

resource "aws_route_table" "public-rt" {
  vpc_id = aws_vpc.daps.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name =  "${var.env_prefix}-pub-rt"
  }
}

resource "aws_route_table_association" "public-subnet-1" {
  subnet_id      = aws_subnet.public-subnet-1.id 
  route_table_id = aws_route_table.public-rt.id
}

resource "aws_route_table_association" "public-subnet-2" {
  subnet_id      = aws_subnet.public-subnet-2.id 
  route_table_id = aws_route_table.public-rt.id
}

# create EIP and Nat-gw 

resource "aws_eip" "eip" {
  domain   = "vpc"
}

resource "aws_nat_gateway" "daps-vpc-nat" {
  allocation_id = aws_eip.eip.id
  subnet_id     = aws_subnet.public-subnet-1.id

  tags = {
    Name = "${var.env_prefix}-NAT"
  }

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.igw]
}

resource "aws_route_table" "private-rt" {
  vpc_id = aws_vpc.daps.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.daps-vpc-nat.id
  }

  tags = {
    Name = "${var.env_prefix}-private-rt"
  }
}

# associate pte subnets 
resource "aws_route_table_association" "private-subnet-1" {
  subnet_id      = aws_subnet.private-subnet-1.id
  route_table_id = aws_route_table.private-rt.id
}

resource "aws_route_table_association" "private-subnet-2" {
  subnet_id      = aws_subnet.private-subnet-2.id
  route_table_id = aws_route_table.private-rt.id
}

# create s-g 
resource "aws_security_group" "daps-vpc-sg" {
  name        = "allow_http/ssh"
  description = "Allow HTTP/SSH inbound traffic"
  vpc_id      = aws_vpc.daps.id

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks =  [ "0.0.0.0/0" ]   #[ var.my_ip ]
  }

  ingress {
    from_port = 8080
    to_port = 8080
    protocol = "tcp"
    cidr_blocks = [ "0.0.0.0/0" ]
  }

  egress {
   from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = [ "0.0.0.0/0" ] 
  }
  tags = {
    Name = "${var.env_prefix}-sg"
  }
} 

