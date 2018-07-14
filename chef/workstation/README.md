# Workstations

A pasta contém arquivos que permitem a criação de uma workstation para uso do chef conforme
tabela abaixo:

Arquivo                          | Descrição
---------------------------------|---------------------------------------------------------------
[Dockerfile-wrk](Dockerfile-wrk) | Cria um container Docker com o chef-dk e terraform instalados
[Vagrantfile](Vagrantfile)       | Cria uma VM local (Virtualbox) contendo chef-dk e terraform
[wrk.tf](wrk.tf)                 | Cria uma instância EC2 contendo chef-dk utilizando o terraform


#### Vagrantfile

Para utilizar o Vagrantfile você terá que ter instalado um provider (VirtualBox, Parallels, etc) e
configurar:

- Uma pasta sincronizada para que a VM tenha acesso aos arquivos de receita que você editar. Veja a
configuração `config.vm.synced_folder` no Vagrantfile;

- Lembre-se de criar uma área para repositório do chef.


#### AWS / Terraform

Como será neccessário conectar-se a máquina para editar os arquivos e executar o chef-client,
você deverá:

- Configurar as credenciais de acesso conforme indicação na aula passada ou utilizar um arquivo
de credenciais. A sua localização está definida nas configurações do provider aws. Veja o formato
do arquivo em [Configuration and Credential Files](https://docs.aws.amazon.com/cli/latest/userguide/cli-config-files.html);

- Informar a chave que será utilizada para criação das máquinas.

Para informar a chave, você deve criar uma chave localmente (ssh keygen) e depois configurá-la no
 terraform. No exemplo abaixo, a chave definida no arquivo my-key.pem é utilizada  


 ```bash
 ssh-keygen -t rsa -b 4096
 chmod 400 my-key.pem
 ```

```
resource "aws_key_pair" "auth" {
  key_name   = "iac"
  public_key = "${file("~/keys/my-key.pub")}"
}
```

Maiores detalhes sobre o uso de chaves no próprio guia do provider AWS no [Terraform](https://www.terraform.io/docs/providers/aws/r/key_pair.html) e na própria [AWS](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ec2-key-pairs.html?icmpid=docs_ec2_console).