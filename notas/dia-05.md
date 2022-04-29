# Dia 05

# Bloco Dinâmico

Exemplo de problema: Criação de Block Storage.

```
resource "aws_instance" "web" {
  ami           = data.aws_ami.ubuntu.id  
  instance_type = "t2.micro"

  ebs_block_device {
      device_name = "/dev/sdg"
      volume_size = 5
      volume_type = "gp2"
  }

  tags = {
    Name = "Servidor Web 1"
  }
}
```

É possível criar block storages de forma mais elegante usando o bloco dinâmico.

Criando dynamic block:

```
resource "aws_instance" "web" {
  ami           = data.aws_ami.ubuntu.id  
  instance_type = "t2.micro"

  dynamic "ebs_block_device" {
      for_each = var.blocks
      content {
        device_name = ebs_block_device.value["device_name"]
        volume_size = ebs_block_device.value["device_size"]
        volume_type = ebs_block_device.value["volume_type"]
      }
  }

  tags = {
    Name = "Servidor Web 1"
  }
}
```

Criando o objeto block (variable):

Crie o arquivo terraform.tfvars:

```
blocks = [
    {
        device_name = "/dev/sdg"
        volume_size = 5
        volume_type = gp2
    },
    {
        device_name = "/dev/sdh"
        volume_size = 10
        volume_type = gp2
    }
]
```

Criando a variável:

```
variable "blocks"{
    type = list(object({
        device_name = string
        volume_size = string
        volume_type = string
    }))
}
```

## String Templates

Tornando as Strings Dinâmicas

Tipos:
- Interpolação
- Diretivas

### interpolação

Exemplo:

```
resource "aws_instance" "web" {
  ami           = data.aws_ami.ubuntu.id  
  instance_type = "t2.micro"

  tags = {
    Name = "Servidor Web ${var.name}"
  }
}
```

Criando variável:

```
variable "name"{
    type = string
    default = "testando interpolação"
    description = "Nome do Helloworld"
}
```

### Diretivas

```
"Hello, %{ if var.name != "" }${var.name}%{ else }unnamed%{ endif }!"
```

## Terraform Cloud

