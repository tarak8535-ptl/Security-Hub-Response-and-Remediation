provider "aws" {
  region = "us-east-1"
}

resource "aws_vpc" "Rp-VPC" {
  cidr_block = "10.0.0.0/16"

  tags = {
    "Name" = "Rp-VPC"
  }
  
}

resource "aws_internet_gateway" "Rp-GW" {
  vpc_id = aws_vpc.Rp-VPC.id

  tags = {
    "Name" = "Rp-GW"
  }
  
}

resource "aws_route_table" "Rp-RT" {
  vpc_id = aws_vpc.Rp-VPC.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.Rp-GW.id
  } 

  route {
    ipv6_cidr_block = "::/0"
    gateway_id = aws_internet_gateway.Rp-GW.id
  }

  tags = {
    "Name" = "Rp-RT"
  }
}

resource "aws_subnet" "Rp-Subnet" {
  vpc_id = aws_vpc.Rp-VPC.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "us-east-1a"

  tags = {
    "Name" = "Rp-Subnet"
  }

}

resource "aws_route_table_association" "Rp-RTA" {
  subnet_id = aws_subnet.Rp-Subnet.id
  route_table_id = aws_route_table.Rp-RT.id
  
}

resource "aws_security_group" "allow_web" {
  name = "allow_web_traffic"
  description = "Allow web inbound traffic"
  vpc_id = aws_vpc.Rp-VPC.id

  ingress {
    description = "HTTPS from VPC"
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP from VPC"
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "SSH from VPC"
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    "Name" = "allow_web"
  }

}

resource "aws_network_interface" "web_server_nic" {
  subnet_id = aws_subnet.Rp-Subnet.id
  private_ip = "10.0.1.50"
  security_groups = [ aws_security_group.allow_web.id ]
  
}

# resource "aws_eip" "one" {
#   vpc = true
#   network_interface = aws_network_interface.web_server_nic.id
#   associate_with_private_ip = "10.0.1.50"
#   depends_on = [
#     aws_internet_gateway.Rp-GW
#   ]

# }


resource "aws_instance" "web-server-ubuntu" {
  ami = "ami-04505e74c0741db8d"
  instance_type = "t2.micro"
  availability_zone = "us-east-1a"
  key_name = "Rp-AccessKey"

  network_interface {
    device_index = 0
    network_interface_id = aws_network_interface.web_server_nic.id
  }

  # user_data = <<-EOF
  #             #!/bin/bash
  #             sudo apt update -y
  #             sudo apt install apache2 -y
  #             sudo systemctl start apache2
  #             sudo bash -c 'echo your very first web server > /var/www/html/index.html'
  #             EOF

  # tags = {
  #   "Name" = "web-server"
  # }

}












