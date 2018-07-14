# Node

### Utilização do Terraform

Para utilização do arquivo [node.tf](node.tf), atente para as seguintes variaveis:

- ukey: O caminho para a chave privada do usuário no servidor chef. Será usada no acesso ao servidor.
Deve estar fisicamente na pasta de configuração *.chef* dentro de seu repositório;

- ssh_private_key: O caminho da chave ssh privada que será usada na criação das máquinas e que você 
poderá utilizar para acessar qualquer máquina criada via ssh;

- ssh_public_key: O caminho da chave pública ssh (a mesma usada na criação da máquina) para registro 
junto a AWS via recurso *aws_key_pair* do Terraform.

Para configurá-las em tempo de execução, você poderá ajustar o valor-padrão de cada uma das informações ou mesmo utilizar um dos métodos para 
[Variáveis de Entrada](https://www.terraform.io/intro/getting-started/variables.html) do Terraform.