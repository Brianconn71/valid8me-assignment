/* 
AWS Provider Configuration.
region set to Ireland: eu-west-1
*/
provider "aws"{
    region = "eu-west-1"
}

# VPC Configuration
resource "aws_vpc" "task-1"{
    cidr_block = "10.0.0.0/16"
    tags = {
        Name = "Task-1 VPC"
    }
}

# Public Subnet A
resource "aws_subnet" "public_a"{
    vpc_id = aws_vpc.task-1.id
    cidr_block = "10.0.1.0/24"
    availability_zone = "eu-west-1a"
    map_public_ip_on_launch = true
    tags = {
        Name = "Public Subnet A"
    }
}

# Public Subnet B
resource "aws_subnet" "public_b"{
    vpc_id = aws_vpc.task-1.id
    cidr_block = "10.0.2.0/24"
    availability_zone = "eu-west-1b"
    map_public_ip_on_launch = true
    tags = {
        Name = "Public Subnet B"
    }
}

# Private Subnet A
resource "aws_subnet" "private_a"{
    vpc_id = aws_vpc.task-1.id
    cidr_block = "10.0.3.0/24"
    availability_zone = "eu-west-1a"
    map_public_ip_on_launch = true
    tags = {
        Name = "Private Subnet A"
    }
}

# Private Subnet B
resource "aws_subnet" "private_b"{
    vpc_id = aws_vpc.task-1.id
    cidr_block = "10.0.4.0/24"
    availability_zone = "eu-west-1b"
    map_public_ip_on_launch = true
    tags = {
        Name = "Private Subnet B"
    }
}
