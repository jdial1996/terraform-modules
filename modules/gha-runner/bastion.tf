resource "aws_instance" "bastion" {
  vpc_security_group_ids = [aws_security_group.bastion_sg.id]
  subnet_id = aws_subnet.public-eu-west-1a.id
  ami = "ami-05e786af422f8082a"
  associate_public_ip_address = true
  key_name = aws_key_pair.key_pair.id
  instance_type = "t2.micro"
  tags = {
    Name = "Bastion"	
    Type = "terraform"
  }
}

resource "aws_security_group" "bastion_sg" {
  name   = "bastion-security-group"
  vpc_id = aws_vpc.main.id

  ingress {
    protocol    = "tcp"
    from_port   = 22
    to_port     = 22
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    protocol    = -1
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}

output "bastion_ip" {
  value = aws_instance.bastion.public_ip
}