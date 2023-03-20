module "vpc" {
  source =  "git::git@github.com:jdial1996/terraform.git//modules/vpc?ref=vpc-v0.1.0"
  environment = "staging"
}

data "aws_ami" "ubuntu-ami" {
  most_recent = true
  owners = ["099720109477"]
  filter {
      name = "architecture"
      values = ["x86_64"] 
  }

  filter {
      name = "virtualization-type"
      values = ["hvm"]
  }

  filter {
      name = "root-device-type"
      values = ["ebs"]
  }
}

resource "aws_security_group" "security_group" {
  name = "sec_group_cloudflared"
  vpc_id = module.vpc.vpc_id
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
      from_port = 22
      to_port = 22 
      protocol = "TCP"
      cidr_blocks = ["0.0.0.0/0"]
  }
}

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

# resource "cloudflare_argo" "example" {
#   zone_id        = var.cloudflare_zone
# }


resource "cloudflare_tunnel" "example" {
  account_id = var.cloudflare_account_id
  name       = "AWS-03"
  secret     = "cGFzc3dvcmQ="
}

resource "aws_instance" "cloudflare_d" {
  vpc_security_group_ids = [aws_security_group.security_group.id]
  subnet_id = module.vpc.public_subnets[0]
  user_data = base64encode(templatefile("scripts/user-data.sh", {
      web_zone = var.cloudflare_zone, 
      account = var.cloudflare_account_id, 
      tunnel_id = cloudflare_tunnel.example.id,
      tunnel_name = cloudflare_tunnel.example.name,
      secret = cloudflare_tunnel.example.tunnel_token
      }))
  key_name = aws_key_pair.key_pair.id
  ami = data.aws_ami.ubuntu-ami.id
  associate_public_ip_address = true
  instance_type = "t2.micro"
  tags = {
    Name = "cloudflared"	
    Type = "terraform"
  }
}

output "public-subnet" {
    value = module.vpc.public_subnets[0]
}
