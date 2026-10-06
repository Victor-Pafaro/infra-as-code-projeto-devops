# 1. Gera uma chave privada RSA
resource "tls_private_key" "pk" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# 2. Cria o Key Pair na AWS usando a chave gerada
resource "aws_key_pair" "generated_key" {
  key_name   = "website-server-key"
  public_key = tls_private_key.pk.public_key_openssh
}

# 3. (Opcional) Guarda a chave privada num arquivo local se precisar acessar via SSH
resource "local_file" "ssh_key" {
  content  = tls_private_key.pk.private_key_pem
  filename = "${path.module}/minha-chave-ec2.pem"
}