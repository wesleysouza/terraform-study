## Comandos Básicos

docker run -it -v $PWD:/app -w /app --entrypoint "" hashicorp/terraform:light sh

### Terraform init

Esse comando vai ler todos os arquivos .tf que estejam no diretório atual.

#### Adicionando as credenciais via variável de ambiente

Passos:
- IAM: Crie uma chave de acesso nova
- Crie as variáveis de ambiente:

export AWS_ACCESS_KEY_ID=valor
export AWS_SECRET_ACCESS_KEY=valor

Após isso podemos rodar o comando init e gerar o backend.

#### Boas prática

Adicione a opção **-upgrade** no init para forçar a atualização dos plugins.

terraform init upgrade

### Terraform plan

Use a opção -out=path para salvar a saída do comando (relatório) em um arquivo, ou seja, use para salvar o plano.

terraform plan -out plano

### Terraform apply

Para aplicar o plano use o comando abaixo:

terraform apply "plano"

### Terraform destroy

Deleta toda a infraestrutura provisionada. É possível fazer um plan do destroy com o comndo abaixo:

terraform plan -destroy

terraform destroy

## Expressions

Tipos e valores:
- **string**: "hello"
- **number**: 1, 6.52
- **bool**: true ou false
- **list (ou tuple)**: ["us-west-la", "us-west-lc"]
- **map (ou object)**: (name = "Mabel", age = 52) 
- **null**: forma de expressar o inexistente e muito utilizado em condicional. Todo o parâmetro que tem o valor **null** é omitido na definição da infraestrutura.

### Referências

Bloco output:

output "ip_address" {
  value = aws_instance.web.public_ip
}

Esse output vai exibir o ip da máquina que foi provisionada.

Apontando para recursos:
- tipo do recurso: aws_instance
- nome: web
- fact: public_ip

### Data

Buscando uma informação dentro do provider.

Buscando a ami e atribuíndo dinâmicamente:


### Terraform Console

terraform console

A ideia do console é interagir com o state. É muito bom para fazer tshot e interagir com os objetos do terraform.

> data.aws_ami.ubuntu

Exibe todo o estado do objeto (o map).

## Providers

provider "google" {
    project = "nome-do-projeto"
    region = "us-central1"
}

### Metaargumento provider

Todo recurso pode ter esse metaargumento. Exemplo:

resource "aws_instance" "web" {
  provider = aws.west
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"

  tags = {
    Name = "HelloWorld"
  }
}

Obs.: Cada recurso deve possuir um nome único!

## Variables

Declarando variáveis:




