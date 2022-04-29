# Dia 03

## Depedência

Um recurso pode depender de outro...

Existem dois tipos de depeências:
- Implícitas: Os recursos tem relação direta, por exemplo, adicionar um elastic IP a uma instância na EC2. Sendo assim o IP só vai existir se a máquina existir tmb.
    - Na destruição acontece o contrário, destroí o IP primeiro e depois a máquina.
- Explícitas: Nesse caso o Terraform não sabe que existe uma dependência. Para declarar explicitamente use o comando **depends_on**.

[Doc](https://learn.hashicorp.com/tutorials/terraform/dependencies)

## Introdução aos comandos e aumentando o verbose deles (Debugging Terraform)

Passar a variável de ambiente TF_LOG com os seguintes níveis:
- TRACE
- DEBUG
- INFO
- WARN
- ERROR

Use da seguinte forma:

```
TF_LOG=DEBUG terraform plan -out plan
```

## Mais comandos (state, taint e untaint)

### Comando state

Comando state list, ler o que está no state e mostra pra a gente:

```
terraform state list
```

Saída:

```bash
data.aws.ami.ubuntu
aws_instance.web[0] #Recurso
aws_instance.web[1] # Recurso
```

### Comando Taint

Marcar que um recurso precisa ser destruído e recriado no plano no próximo apply. Esse comando é utilizado quando é necessário deletar e recriar um recurso.

Uso do comando:

```
terraform taint [options] address (aws_instance.web[0])
```

desfazendo:

```
terraform untaint [options] address (aws_instance.web[0])
```

## Terraform Graph

Esse é o comando responável por pegar o grafo do terraform e exibir pra vc. Ele é usado para gerar uma representação visual do seu plano.

Instala o pacote graphviz

```
apk -U add graphviz
```

```
terraform graph | dot . Tsvg > graph.svg
```

## Terraform fmt

Esse comando mexe nos arquivos e coloca-os na formatação correta.

Aplicando a formatação recursivamente na pasta e subpastas.

```
terraform fmt -recursive
```

### Verificando código de saída

Para ver o código de saída do último comando no linux faça:

```bash
echo $?
```

Se o código de saída não for 0 ocorreu um erro.

Se o seu código estiver em um pipeline e for aplicado o fmt se der um erro o pipeline pode quebrar!

```
terraform fmt -check
```

Para ver mais detalhes dos arquivos fora da formatação use o diff

```
terraform fmt -check -diff
```

Corrigindo e mostrando as diferenças

```
terraform fmt -diff
```

## Comando Terraform Validate

Esse comando é muito importante se você for fazer um pipeline CI. A ideia desse comando é validar se o código terraform tem um erro sintático. Ele é rápido e pelas definições de CI ele deve ser colocado primeiro.

```
terraform validate -json
```



