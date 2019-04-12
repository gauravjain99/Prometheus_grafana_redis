resource "aws_vpc" "elasticvpc" {
  cidr_block           = "${var.network_address_space}"
  enable_dns_hostnames = "${var.enable_dns_hostnames}"
}

resource "aws_internet_gateway" "natigw" {
  vpc_id = "${aws_vpc.elasticvpc.id}"
}

resource "aws_subnet" "public_subnet" {
  cidr_block              = "${var.subnet_address_space}"
  vpc_id                  = "${aws_vpc.elasticvpc.id}"
  map_public_ip_on_launch = "true"
}

resource "aws_route_table" "public_route_table" {
  vpc_id = "${aws_vpc.elasticvpc.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.natigw.id}"
  }
}

resource "aws_route_table_association" "table_public" {
  subnet_id      = "${aws_subnet.public_subnet.id}"
  route_table_id = "${aws_route_table.public_route_table.id}"
}

# Security groups

resource "aws_security_group" "redis" {
  name   = "redis"
  vpc_id = "${aws_vpc.elasticvpc.id}"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 6379
    to_port     = 6379
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 9121
    to_port     = 9121
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "prometheus" {
  name   = "prometheus"
  vpc_id = "${aws_vpc.elasticvpc.id}"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 9090
    to_port     = 9090
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }
}
