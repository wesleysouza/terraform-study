data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  owners = ["099720109477"] # Ubuntu (Dono da imagem)
}

resource "aws_instance" "web" {
  count         = var.servers
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"

  tags = {
    Name = "Servidor Web 1"
  }
}

resource "aws_eip" "ip" {
  vpc      = true
  instance = aws_instance.web.id
}

resource "aws_instance" "web2" {
  count         = var.servers
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"

  tags = {
    Name = "Servidor Web 2"
  }

  depends_on = [
    aws_instance.web
  ]
}