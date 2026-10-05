resource "aws_instance" "website_server" {
  ami                    = "ami-0d3d85815a9746bc5" #Amazon Linux 2 AMI
  instance_type          = "t3.micro"
  key_name               = aws_key_pair.generated_key.key_name
  vpc_security_group_ids = [aws_security_group.website_sg.id]
  iam_instance_profile   = "ECR-EC2-Role"

  tags = {
    Name        = "website-server"
    Provisioned = "Terraform"
  }
}

resource "aws_security_group" "website_sg" {
  name   = "allow_tls"
  vpc_id = "vpc-0618f447c61b885f2"

  tags = {
    Name        = "website-sg"
    Provisioned = "Terraform"
  }
}

#Regra de entrada para ssh
resource "aws_vpc_security_group_ingress_rule" "allow_ssh" {
  security_group_id = aws_security_group.website_sg.id

  cidr_ipv4   = "187.125.120.45/32"
  from_port   = 22
  ip_protocol = "tcp"
  to_port     = 22
}

#Regra de entrada para http
resource "aws_vpc_security_group_ingress_rule" "allow_http" {
  security_group_id = aws_security_group.website_sg.id

  cidr_ipv4   = "0.0.0.0/0"
  from_port   = 80
  ip_protocol = "tcp"
  to_port     = 80
}

#Regra de entrada para https
resource "aws_vpc_security_group_ingress_rule" "allow_htts" {
  security_group_id = aws_security_group.website_sg.id

  cidr_ipv4   = "0.0.0.0/0"
  from_port   = 443
  ip_protocol = "tcp"
  to_port     = 443
}

#Regra de saída para acesso a internet
resource "aws_vpc_security_group_egress_rule" "allow_all_outbound" {
  security_group_id = aws_security_group.website_sg.id

  cidr_ipv4   = "0.0.0.0/0"
  ip_protocol = -1
}