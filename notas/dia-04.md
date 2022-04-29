# Dia 4

## Espressões Condições

Sintaxe (operador ternário): 

```
condition ? true_val : false_val
```

Criando count na aws_instance:

Crie a variável:

```
variable "environment" {
    default = "staging"
}
```

Subindo número de instâncias diferentes observado o ambiente:

```
resource "aws_instance" "web" {
  count         = var.enviroment == "production" ? 2 : 1
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"

  tags = {
    Name = "Servidor Web 1"
  }
}
```

Criando variável plus:

```
variable "plus" {
    default = 2
}
```

Colocando a expressão dentro do operador ternário:

```
count = var.enviroment == "production" ? 2 + var.plus : 1
```

Operador ternário com apenas um componente:

```
count = var.production ? 2 : 1
```

Definição da variável production:

```
variable "production" {
    default = true
}
```

Obs.: Coloque variáveis em tudo, quanidade de máquinas e etc.

## Mundando o instance_type

Podemos mudar manipulando o count index:

```
resource "aws_instance" "web" {
  count         = var.enviroment == "production" ? 2 : 1
  ami           = data.aws_ami.ubuntu.id
  instance_type = count.index < 1 ? "t2.micro" : "t3.medium"

  tags = {
    Name = "Servidor Web 1"
  }
}
```

## Type constraints

Esse **type constraints** é muito usando na construção de módulos. 

Trabalhando com restrições de tipo para input.

### Tipos complexos

- Collection Types: listas e mapas.

Exemplo de Type Constraints:

Criando variável environment:

```bash
variable "environment" {
    type = string #esse inout só aceita string
    default = "staging"
    description = "The enviroment of instance"
}
```

Aplicando na criação do recurso:

```
resource "aws_instance" "web" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"

  tags = {
    Name = "Servidor Web 1"
    Env = var.environment
  }
}
```

Passando variável por linha de comando:

```
export TF_VAR_environment=12345
```

Esse input apesar de ser inteiro ele passa pra String.

## Laço for_each

É bom para passar variáveis diferentes a cada execução do loop.

Obs.: O for_each só aceita map ou um set de Strings.

Criando instâncias de instance_types diferentes:

```
resource "aws_instance" "web" {
  ami           = data.aws_ami.ubuntu.id
  for_each = {
    dev = "t2.micro"
    staging = "t3.micro"
  }
  
  instance_type = each.value

  tags = {
    Name = "Servidor Web 1"
    Env = var.environment
  }
}
```

Fazendo de uma forma diferente (usando variáveis:

```bash
variable "instance_type" {
    type = list(string)
    default = ["t2.micro", "t3.medium"]
    description = "The list of instance type"
}
```

```
resource "aws_instance" "web" {
  ami           = data.aws_ami.ubuntu.id
  for_each = toset(vat.instance_type)
  
  instance_type = each.value

  tags = {
    Name = "Servidor Web 1"
    Env = var.environment
  }
}
```

É necessário fazer outro laço no output.

```
output "ip_address" {
  value = {
    for instance in aws_instance.web:
    instance.id => instance.private_ip
  }
}
```

**IMPORTANTE: O bom uso do for_each é quando é necessário passar variáveis diferentes.**