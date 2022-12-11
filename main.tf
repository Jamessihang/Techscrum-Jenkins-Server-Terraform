# configured aws provider with proper credentials
provider "aws" {
  region    = "ap-southeast-2"
  profile   = "SIHANG"
}


# create default vpc if one does not exit
resource "aws_default_vpc" "default_vpc" {

  tags    = {
    Name  = "default vpc"
  }
}


# use data source to get all avalablility zones in region
data "aws_availability_zones" "available_zones" {}


# create default subnet if one does not exit
resource "aws_default_subnet" "default_az1" {
  availability_zone = data.aws_availability_zones.available_zones.names[0]

  tags   = {
    Name = "default subnet"
  }
}


# create security group for the ec2 instance
resource "aws_security_group" "jenkins_security_group" {
  name        = "jenkins security group"
  description = "allow access on ports 8080 and 22"
  vpc_id      = aws_default_vpc.default_vpc.id

  # allow access on port 8080
  ingress {
    description      = "http proxy access"
    from_port        = 8080
    to_port          = 8080
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  # allow access on port 22
  ingress {
    description      = "ssh access"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = -1
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags   = {
    Name = "Techscrum Jenkins server security group"
  }
}

resource "aws_internet_gateway" "jenkins_igw" {
  vpc_id    = aws_default_vpc.default_vpc.id

  tags      = {
    Name    = "Jenkins igw"
  }
}

# Create public route table 
resource "aws_route_table" "jenkins_public_route_table" {
  vpc_id       = aws_default_vpc.default_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.jenkins_igw.id
  }

  tags       = {
    Name     = "Jenkins route table"
  }
}

# Associate public subnets to public route table
resource "aws_route_table_association" "jenkins_route_table_association" {
  subnet_id           = aws_default_subnet.default_az1.id
  route_table_id      = aws_route_table.jenkins_public_route_table.id
}

# use data source to get a registered amazon linux 2 ami
data "aws_ami" "amazon_linux_2" {
  most_recent = true
  owners      = ["amazon"]
  
  filter {
    name   = "owner-alias"
    values = ["amazon"]
  }

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm*"]
  }
}


# launch the ec2 instance
resource "aws_instance" "ec2_instance" {
  ami                    = data.aws_ami.amazon_linux_2.id
  instance_type          = "t2.micro"
  subnet_id              = aws_default_subnet.default_az1.id
  vpc_security_group_ids = [aws_security_group.jenkins_security_group.id]
  key_name               = "Jenkins_key"
  iam_instance_profile = aws_iam_instance_profile.ec2_profile.name
  # user_data            = file("install_jenkins.sh")

  tags = {
    Name = "Techscrum Jenkins Server"
  }
}

#Create a role
resource "aws_iam_role" "ec2_role" {
  name = "ec2_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })
}

#Get ploicy information
data "aws_iam_policy" "ec2" {
  arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

#Attach role to policy
resource "aws_iam_policy_attachment" "ec2_policy_role" {
  name       = "ec2_attachment"
  roles      = [aws_iam_role.ec2_role.name]
  policy_arn = data.aws_iam_policy.ec2.arn
}

#Attach role to an instance profile
resource "aws_iam_instance_profile" "ec2_profile" {
  name = "ec2_profile"
  role = aws_iam_role.ec2_role.name
}

# an empty resource block
resource "null_resource" "name" {

  # ssh into the ec2 instance 
  connection {
    type        = "ssh"
    user        = "ec2-user"
    private_key = file("~/Downloads/Jenkins_key.pem")
    host        = aws_instance.ec2_instance.public_ip
  }

  # copy the install.sh file from your computer to the ec2 instance 
  provisioner "file" {
    source      = "install.sh"
    destination = "/tmp/install.sh"
  }

  # set permissions and run the install.sh file
  provisioner "remote-exec" {
    inline = [
      "sudo chmod +x /tmp/install.sh",
      "sh /tmp/install.sh",
    ]
  }

  # wait for ec2 to be created
  depends_on = [aws_instance.ec2_instance]
}


# print the url of the jenkins server
output "website_url" {
  value     = join ("", ["http://", aws_instance.ec2_instance.public_dns, ":", "8080"])
}
