
# Move GHA instance into private subnet 
    # - add NAT gateway
    # - make new subnet private by making sure it has a route to the NAT gateway 

resource "aws_vpc" "main"  {
    cidr_block = "10.0.0.0/16"

    tags = {
        Name = "github-actions-runner"
    }
}

resource "aws_subnet" "public-eu-west-1a" {
    vpc_id = aws_vpc.main.id
    cidr_block = "10.0.0.0/25"
    availability_zone = "eu-west-1a"

    tags = {
        "Name" = "gha-public-eu-west-1a"
    }
}

resource "aws_subnet" "private-eu-west-1a" {
    vpc_id = aws_vpc.main.id
    cidr_block = "10.0.0.128/25"
    availability_zone = "eu-west-1a"

    tags = {
        "Name" = "gha-private-eu-west-1a"
    }
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat.id
  }

  tags = {
    Name = "private"
  }
}

resource "aws_route_table_association" "private-eu-west-1a" {
  subnet_id      = aws_subnet.private-eu-west-1a.id
  route_table_id = aws_route_table.private.id
}

resource "aws_eip" "nat" {
    vpc = true 

    tags = {
        name = "nat"
    }
}

resource "aws_nat_gateway" "nat" {
    allocation_id  = aws_eip.nat.id
    subnet_id = aws_subnet.public-eu-west-1a.id
    
    tags = {
        name = "nat"
    }

    depends_on = [aws_internet_gateway.main_igw]
}




resource "aws_internet_gateway" "main_igw" {
    vpc_id = aws_vpc.main.id

    tags = {
        Name = "github-actions-igw"
    }
}


resource "aws_route_table" "public_route" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main_igw.id
  }
}

resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.public-eu-west-1a.id
  route_table_id = aws_route_table.public_route.id
}

resource "aws_security_group" "security_group" {
  name = "sec_group_github_runner"
  vpc_id = aws_vpc.main.id
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

resource "aws_instance" "gha_runner" {
  vpc_security_group_ids = [aws_security_group.security_group.id]
  subnet_id = aws_subnet.private-eu-west-1a.id
  associate_public_ip_address = true
  launch_template {
      id = aws_launch_template.github_action_runner.id
  }
  tags = {
    Name = "GitHub-Runner"	
    Type = "terraform"
  }
}

resource "aws_key_pair" "aws_key" {
  key_name   = "aws_key"
  public_key = var.aws_key
}

resource "aws_launch_template" "github_action_runner" {
    name = "github_runner_launch_template"
    image_id = "ami-05e786af422f8082a"
    instance_type = "t2.micro"
    user_data = base64encode(templatefile("scripts/user-data.sh", {personal_access_token = var.personal_access_token, github_user = var.github_user, github_repo = var.github_repo}))
    key_name = aws_key_pair.aws_key.id
    tags = {
		Name = "GitHub-Runner"	
		Type = "terraform"
	}
}

output "runner_public_ip" {
  value = aws_instance.gha_runner.public_ip
}

output "runner_private_ip" {
  value = aws_instance.gha_runner.private_ip
}