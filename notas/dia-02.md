# Dia 02

## Módulos

Módulos é a forma que você pode reunir todas as suas configurações (data, recursos, outputs) do seu Terraform em um só lugar.

Pra quem é desenvolvedor o módulo parece uma classe (ou método).

O ideial é que o bloco provider e terraform deve estar no seu **root module**.

Chamando um módulo: 

```terraform
module "servers" {
  # De onde pegar o módulo
  source = "./app-cluster"
  # Parâmetros (input)
  servers = 5
}
```

Dentro do módulo, tudo o que não for **source**, **version** e **provider** é **input**!

## Backend

Salvando o estado remoto localmente:

terraform state pull >> aula-backend.tfstate

Editando o state e subindo modificações.

terraform state push aula-backend.tfstate

Para fazer essa alteração é necessário mudar o serial que fica abaixo do campo version.

### State locking

Habilidade de o seu backend oferecer de bloquear escrita no state. Esse locking é bom para evitar modificações em paralelo que podem causar conflito.

Para usar o loking é necessário criar um DynamoDB

Criando o DynamoDB (Banco de dados No-SQL baseado em key-value)

Crie o arquivo dynamodb.tf com o conteúdo:

```terraform
resource "aws_dynamodb_table" "dynamodb-terraform-state-lock" {
	name = "terraform-state-lock-dynamo"
	hash_key = "LockID"
	read_capacity = 20
	white_capacity = 20

	attribute {
		name = "LockID"
		type = "S"
	}

	tags = {
		name = "DynamoDB Terraform State Lock Table"
	}
}
```

Adicione a linha abaixo no arquivo main no bloco terraform:

```
dynamodb_table = "terraform-state-lock-dynamo"
```

Com essa configuração o Terraform sabe que estamos pedindo pra usar a função de lock.

### Destruíndo os recursos

Qaundo o lock está ativado, no momento de destruir os recursos pode dar erro pois o dynamodb também será destruído. Sendo assim, existe duas formas de resolver, a primeira e a mais simples é usando o comando abaixo:

```
terraform destroy -lock=false
```

A segunda é removendo a linha dynamodb_table do seu backend.

Para recriar é necessário também ignorar o lock:

```
terraform plan -out plan -lock=false
terraform apply -lock=false "plano"
```

## State

O Terraform não funciona sem state, ele existe para mapear o mundo real. O state mapeia o mundo real (resource da cloud) com as definições do arquivo HCL.

Os metadata ajudam a mapear depedências de recursos.

Desempenho: mini-cache. Para infraestruturas pequenas ele atualiza o state antes do plan e apply. Se fosse verificar todos os recursos em infraestruturas grandes ia demorar muito.

Syncing: Remote state com remote locking é recomendado.

### Refresh

Baixando o state pra um arquivo: 

```
terraform state pull >> state-aula.tfstate
```

O comando refresh vai no provedor e pega as informações para atualizar o state.

```
terraform refresh
```

Alguma coisa que vc fez na mão, vc pode pegar todas as informações que estão lá na nuvem.

Obs.: existe um binário jq para manipulação de arquivos .json

## State avançado (Comando State)

Comando responsável por manipular no arquivo de estado terraform.

Obs.: Não é recomendado mexer no arquivo de state manualmente.

```
terraform state
```

Para cada manipulação é forçadamente criado um backup.

Listando todos os recursos:

```
terraform state list
```

O comando rm retira recursos de sua gerência:

```
terraform state rm module.app.aws_instance.web2
```

## Importando Recursos (Terraform Import)

Não gera código, apenas traz para o state.

Exemplo:

```
terraform import aws_instance.web id
```

Antes de importar o recurso é necessário adicionar ele no root module. No caso da aws vc precisa pegar os argumentos necessários. Para fazer isso podemos usar os comandos abaixo após o plan:

terraform state pull >> testando import.tfstate

Depois é só entrar no arquivo import e pegar as informações necessárias.

### Importações complexas

Esse tipo de importação importa recursos que são relacionados, ou seja, um depende do outro (ex.: security group).

## Terraform Workspace

É como se fosse uma entidade a parte, é uma possibilidade que vc aponte para o mesmo backend, mas que na verdade vc vai ter acesso a uma instância nova do seu state file. Nesse caso, você tem múltiplos states files para armazenar o estado.

Por padrão já existe um workspace chamado default.

Obs.: O Workspace trabalha apenas a nível de state.

Criando o workspace bar:

```
terraform workspace new bar
```

Criando os workspaces staging e production.

Obs.: Cria um arquivo de state para cada workspace. 

-> Os ambientes diferentes em regiões diferentes usando interpolação.

## Interpolação

Podemos aplicar a interpolação na region para criar ambientes de produção e staging:

```
provider "aws" {
  region  = "${terraform.workspace == "production" ? "us-east-1" : "us-east-2"}"
  version = "~> 3.0"
}
```

É uma forma de evitar conflitos entre os recursos.

## Dados sensíveis dentro do state file

Não podemos commitar o state, o state local é perigoso por isso, logo devemos usar um state remoto.

### Encriptando o seu backend no S3

Para fazer isso basta apenas adicionar o parâmetro encrypt = true no seu backend.