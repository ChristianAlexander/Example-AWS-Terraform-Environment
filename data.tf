data "aws_availability_zones" "all" {}

data "http" "my_ip" {
  url = "http://icanhazip.com"
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-trusty-14.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

data "template_file" "ssh_config" {
  template = file("${path.module}/templates/ssh_config.tpl")
  vars = {
    key_file_path       = var.key_file_path
    private_instance_ip = aws_instance.b.private_ip
    public_instance_ip  = aws_instance.a.public_ip
  }
}
