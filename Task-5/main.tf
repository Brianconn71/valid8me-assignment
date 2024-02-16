/* 
AWS Provider Configuration.
region set to Ireland: eu-west-1
*/
provider "aws"{
    region = "eu-west-1"
}

# VPC Configuration
resource "aws_vpc" "task-5"{
    cidr_block = "10.0.0.0/16"
    tags = {
        Name = "Task-5 VPC"
    }
}

# Public Subnet A
resource "aws_subnet" "public_a"{
    vpc_id = aws_vpc.task-5.id
    cidr_block = "10.0.1.0/24"
    availability_zone = "eu-west-1a"
    map_public_ip_on_launch = true
    tags = {
        Name = "Public Subnet A"
    }
}

# Public Subnet B
resource "aws_subnet" "public_b"{
    vpc_id = aws_vpc.task-5.id
    cidr_block = "10.0.2.0/24"
    availability_zone = "eu-west-1b"
    map_public_ip_on_launch = true
    tags = {
        Name = "Public Subnet B"
    }
}

# Private Subnet A
resource "aws_subnet" "private_a"{
    vpc_id = aws_vpc.task-5.id
    cidr_block = "10.0.3.0/24"
    availability_zone = "eu-west-1a"
    map_public_ip_on_launch = false
    tags = {
        Name = "Private Subnet A"
    }
}

# Private Subnet B
resource "aws_subnet" "private_b"{
    vpc_id = aws_vpc.task-5.id
    cidr_block = "10.0.4.0/24"
    availability_zone = "eu-west-1b"
    map_public_ip_on_launch = false
    tags = {
        Name = "Private Subnet B"
    }
}

# Security Group
resource "aws_security_group" "web_access" {
    name = "allow_web_and_ssh"
    vpc_id = aws_vpc.task-5.id

    # allow SSH on port 22
    ingress {
        from_port   =       22
        to_port     =       22
        protocol    =       "tcp"
        cidr_blocks =       ["84.21.169.116/32"]
    }

    # allow http on port 80
    ingress {
        from_port   =       80
        to_port     =       80
        protocol    =       "tcp"
        cidr_blocks =       ["0.0.0.0/0"]
    }

    egress {
        from_port   =       0
        to_port     =       0
        protocol    =       "-1"
        cidr_blocks =       ["0.0.0.0/0"]
    }

    tags = {
        Name = "Web and SSH Access"
    }
}


# EC2 Instance
resource "aws_instance" "task-5_ec2" {
    ami                     = data.aws_ami.task2-amazon_linux.id
    instance_type           = "t2.micro"
    subnet_id               = aws_subnet.public_a.id
    vpc_security_group_ids  = [aws_security_group.web_access.id]
    key_name                = data.aws_key_pair.imported_key.key_name

    # User Data Script
    user_data = base64encode(file("install_nginx.sh")) 

    tags = {
        Name = "Task-5 EC2 Instance"
    }
}

# The Data source for t2.micro AMI
data "aws_ami" "task2-amazon_linux" {
    most_recent = true
    
    filter {
        name = "name"
        values = ["amzn2-ami-hvm-*x86_64-gp2"]
    }
    filter {
        name = "virtualization-type"
        values = ["hvm"]
    }
    
    owners= ["amazon"]
}

# The Data source for the key pair from a created keypair on aws
resource "aws_key_pair" "imported_key" {
  public_key = "Brian-Terraform-local"
}

# Internet Gateway setup
resource "aws_internet_gateway" "vpc_igw" {
    vpc_id = aws_vpc.task-5.id
}

# Route Table setup
resource "aws_route_table" "public_route_table" {
    vpc_id = aws_vpc.task-5.id 
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.vpc_igw.id
    }
} 

# Route Table Association setup
resource "aws_route_table_association" "public_subnet_a_assoc" {
    subnet_id      = aws_subnet.public_a.id
    route_table_id = aws_route_table.public_route_table.id
}