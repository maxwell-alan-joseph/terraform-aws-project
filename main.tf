#defining aws provider
provider "aws" {
    region = "us-east-1"
}

#defining VPC 
resource "aws_vpc" "my_vpc" {
    cidr_block = "10.0.0.0/16" #defines the address range for the VPC
    enable_dns_support = true
    enable_dns_hostnames = true

    tags = {
        Name = "MyVPC"
    }
}

#defining subnets 
resource "aws_subnet" "public_subnet" {
    vpc_id = aws_vpc.my_vpc.id
    cidr_block = "10.0.1.0/24"
    availability_zone = "us-east-1a"
    map_public_ip_on_launch = true

    tags = {
        Name = "Public Subnet"
    }
}
#private subnet 
resource "aws_subnet" "private_subnet" {
    vpc_id = aws_vpc.my_vpc.id
    cidr_block = "10.0.2.0/24"
    availability_zone = "us-east-1b"

    tags = {
        Name = "Private Subnet"
    }
}

#defining security group 
resource "aws_security_group" "my_security_group" {
    name  = "my_security_group"
    description = "Allow inbound traffic on port 22 (SSH) and 80 (HTTP)"

    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port =  0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}

#defining EC2 instance 
resource "aws_instance" "my_instance" {
    ami = "ami-0c55b159cbfafe1f0" #replace with desired AMI Id
    instance_type = "t2.micro"
    subnet_id = aws_subnet.public_subnet.id
    security_groups = [aws_security_group.my_security_group.id]
    key_name = "your-key-pair-name" #replace with your key pair name
    

    tags = {
        Name = "MyEC2Instance"
    }
}

#defining s3 bucket
resource "aws_s3_bucket" "my_bucket" {
    bucket = "my-terraform-bucket-12345" #replace with desired bucket name

    tags = {
        Name = "MyS3Bucket"
    }
}
