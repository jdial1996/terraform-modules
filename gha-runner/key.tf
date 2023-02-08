resource "tls_private_key" "private_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "key_pair" {
  key_name   = var.key_name
  public_key = tls_private_key.private_key.public_key_openssh
  depends_on = [tls_private_key.private_key]
}

resource "local_file" "saveKey" {
  content = tls_private_key.private_key.private_key_pem
  filename = pathexpand("~/.ssh/aws_rsa")
  
}