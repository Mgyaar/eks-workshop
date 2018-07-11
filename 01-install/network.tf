resource "aws_vpc" "kubernetes" {
  cidr_block           = "10.4.0.0/16"
  enable_dns_hostnames = true

  tags {
    CostCenter                  = "infrastructure"
    Name                        = "kubernetes"
    "kubernetes.io/cluster/eks" = "shared"
  }
}

resource "aws_route53_zone" "internal" {
  name = "${lookup(var.name, terraform.workspace)}.kubernetes"

  vpc_id = "${aws_vpc.kubernetes.id}"
}

data "aws_availability_zones" "az" {}

resource "aws_subnet" "public-subnet" {
  count             = "3"
  vpc_id            = "${aws_vpc.kubernetes.id}"
  availability_zone = "${data.aws_availability_zones.az.names[count.index+1]}"
  cidr_block        = "10.4.${count.index+1}.0/24"

  tags = {
    Name                        = "subnet-${lookup(var.name, terraform.workspace)}-${count.index}"
    CostCenter                  = "infrastructure"
    "kubernetes.io/cluster/eks" = "shared"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = "${aws_vpc.kubernetes.id}"
}

resource "aws_route_table" "route-table" {
  vpc_id = "${aws_vpc.kubernetes.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.igw.id}"
  }
}

resource "aws_route_table_association" "subnet-table-association" {
  count          = 3
  subnet_id      = "${element(aws_subnet.public-subnet.*.id, count.index)}"
  route_table_id = "${aws_route_table.route-table.id}"
}

resource "aws_security_group" "kubernetes" {
  name        = "${lookup(var.name, terraform.workspace)}-kubernetes"
  description = "Allow Kubernetes Access"
  vpc_id      = "${aws_vpc.kubernetes.id}"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
