data "aws_ami" "ubuntu" {
    most_recent = true

    filter {
        name = "name"
        values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
    }

    filter {
        name = "virtualization-type"
        values = ["hvm"]
    }

    owners = ["099720109477"] # Canonical
}

resource "aws_instance" "ansible-lab" {
  ami = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
  key_name = "aws_key"
  vpc_security_group_ids = [aws_security_group.my_first-sec-group.id]

  tags = {
    "function" = "ansible-lab"
  }
}

resource "aws_security_group" "my_first-sec-group" {
  egress = [
    {
      cidr_blocks      = [ "0.0.0.0/0", ]
      description      = ""
      from_port        = 0
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      protocol         = "-1"
      security_groups  = []
      self             = false
      to_port          = 0
    }
  ]
 ingress                = [
   {
     cidr_blocks      = [ "0.0.0.0/0", ]
     description      = ""
     from_port        = 22
     ipv6_cidr_blocks = []
     prefix_list_ids  = []
     protocol         = "tcp"
     security_groups  = []
     self             = false
     to_port          = 22
  }
  ]
}

resource "aws_key_pair" "my_key_pair" {
    key_name = "aws_key"
    public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDJs/apukBCoFNDH6oXGZAYwAZfygsUSSFLkB1Lh62el4CE152QdWI7Kl647nXJvbi7xUsxOUJU6+8zLgP6WCcUEfIzgOS9GhT+he2VlLLJsFcmmRRDbQO5HGfnNa4Prtf0+Vwzmh2PHD/McnGOZiAwguHORtE93XNd7Dbti4YQsXyxFvoJ2HBFXKFCZSmCgouwdofgThlQyJFD+gV/4piHaVfkoY+gIhpkDl81Jfe4S4Op1UudQcvWBdYRBYDchKoKCl09cWsHDrLQhbtIouBtgoRAFAv3iXXXVjhAtP9hyZisc3pPUiFmkav6UPM3wVmwaC0d9l03fl9eg/9uZ4ZgRNR/mscZbau4wD9XsnJPhIj9GyOojISpTLwLLPZW1XDQMwTqCxMdY4+zRwyWKlK5fBGttQ1SvD9WZc5PRCIDp0nMKrGVDC3DCCTQpav/+jD8hq5FfSfUii4UpAhY8Tkg3hXFLhNcBLma4LpFoSBmBuFg7wH8zdEQPUCT8NLUNVk= wesley@sagan"
}