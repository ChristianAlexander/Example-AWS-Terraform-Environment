resource "aws_vpc" "demo" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.demo.id
}

resource "aws_default_route_table" "demo" {
  default_route_table_id = aws_vpc.demo.default_route_table_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }
}

resource "aws_subnet" "demo" {
  count             = length(data.aws_availability_zones.all.names)
  vpc_id            = aws_vpc.demo.id
  availability_zone = element(data.aws_availability_zones.all.names, count.index)
  cidr_block        = cidrsubnet(aws_vpc.demo.cidr_block, 8, count.index)
}

resource "aws_security_group" "a" {
  name_prefix = "sg_a"
  description = "Instances SSH-able over the public internet from my IP."

  vpc_id = aws_vpc.demo.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [local.my_ip_cidr]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "b" {
  name_prefix = "sg_b"
  description = "Instances which can only be connected to from an instance in ${aws_security_group.a.name}."

  vpc_id = aws_vpc.demo.id

  ingress {
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.a.id]
  }
}

resource "aws_key_pair" "me" {
  key_name_prefix = "demo"
  public_key      = file("${var.key_file_path}.pub")
}

resource "aws_instance" "a" {
  instance_type               = "t3.nano"
  ami                         = "${data.aws_ami.ubuntu.id}"
  subnet_id                   = aws_subnet.demo[0].id
  vpc_security_group_ids      = [aws_security_group.a.id]
  associate_public_ip_address = true
  key_name                    = aws_key_pair.me.key_name

  tags = {
    Name        = "A"
    Description = "Public-facing instance"
  }
}

resource "aws_instance" "b" {
  instance_type               = "t3.nano"
  ami                         = "${data.aws_ami.ubuntu.id}"
  subnet_id                   = aws_subnet.demo[1].id
  vpc_security_group_ids      = [aws_security_group.b.id]
  associate_public_ip_address = false
  key_name                    = aws_key_pair.me.key_name

  tags = {
    Name        = "B"
    Description = "Private-only instance"
  }
}
