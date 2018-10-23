data "aws_availability_zones" "available" {}

locals {
  common_tags = {
    Owner       = "${var.owner}"
    Purpose     = "${var.purpose}"
    Environment = "${var.environment}"
  }

  name_prefix = "${var.owner}-${var.environment}"
}

# Create a VPC to launch our instances into
resource "aws_vpc" "vpc" {
  cidr_block = "${var.vpc_cidr}"

  tags = "${merge(
      local.common_tags,
      map(
        "Name", "${local.name_prefix}-vpc"
      )
    )}"
}

resource "aws_internet_gateway" "igw" {
  vpc_id = "${aws_vpc.vpc.id}"

  tags = "${merge(
      local.common_tags,
      map(
        "Name", "${local.name_prefix}-igw"
      )
    )}"
}

resource "aws_subnet" "public_subnet" {
  count             = "${var.subnet_count}"
  vpc_id            = "${aws_vpc.vpc.id}"
  cidr_block        = "${cidrsubnet(var.vpc_cidr, 8, count.index)}"
  availability_zone = "${element(data.aws_availability_zones.available.names, count.index)}"

  tags = "${merge(
      local.common_tags,
      map(
        "Name", "${local.name_prefix}-public-subnet-${count.index}"
      )
    )}"
}

resource "aws_subnet" "private_subnet" {
  count             = "${var.subnet_count}"
  vpc_id            = "${aws_vpc.vpc.id}"
  cidr_block        = "${cidrsubnet(var.vpc_cidr, 8, count.index + var.subnet_count)}"
  availability_zone = "${element(data.aws_availability_zones.available.names, count.index)}"

  tags = "${merge(
      local.common_tags,
      map(
        "Name", "${local.name_prefix}-private-subnet-${count.index}"
      )
    )}"
}

resource "aws_default_route_table" "default_route_table" {
  default_route_table_id = "${aws_vpc.vpc.default_route_table_id}"

  route {
    cidr_block = "${var.anywhere_cidr}"
    gateway_id = "${aws_internet_gateway.igw.id}"
  }

  tags = "${merge(
      local.common_tags,
      map(
        "Name", "${local.name_prefix}-default-route-table"
      )
    )}"
}

resource "aws_route_table_association" "default_route_table_association" {
  count          = "${var.subnet_count}"
  subnet_id      = "${element(aws_subnet.public_subnet.*.id, count.index)}"
  route_table_id = "${aws_default_route_table.default_route_table.id}"
}

resource "aws_route_table" "private_route_table" {
  vpc_id = "${aws_vpc.vpc.id}"

  route {
    cidr_block     = "${var.anywhere_cidr}"
    nat_gateway_id = "${aws_nat_gateway.ngw.id}"
  }

  tags = "${merge(
      local.common_tags,
      map(
        "Name", "${local.name_prefix}-private-route-table"
      )
    )}"
}

resource "aws_route_table_association" "private_route_table_association" {
  count          = "${var.subnet_count}"
  subnet_id      = "${element(aws_subnet.private_subnet.*.id, count.index)}"
  route_table_id = "${aws_route_table.private_route_table.id}"
}

resource "aws_eip" "elastic_ip" {
  vpc = true
}

resource "aws_nat_gateway" "ngw" {
  allocation_id = "${aws_eip.elastic_ip.id}"
  subnet_id     = "${aws_subnet.private_subnet.*.id[0]}"

  tags = "${merge(
      local.common_tags,
      map(
        "Name", "${local.name_prefix}-nat"
      )
    )}"
}

