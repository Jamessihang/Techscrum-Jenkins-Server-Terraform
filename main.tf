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

data "external" "my_ip" {
  program = ["sh", "my_ip.sh" ]
}

output "commandout" {
  value = "${data.external.my_ip.result}"
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
    cidr_blocks      = ["${data.external.my_ip.result}"]
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

# create security group for the ec2 instance
resource "aws_security_group" "sonarqube_security_group" {
  name        = "jenkins security group"
  description = "allow access on ports 8080 and 22"
  vpc_id      = aws_default_vpc.default_vpc.id

  # allow access on port 9000
  ingress {
    description      = "http proxy access"
    from_port        = 9000
    to_port          = 9000
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  # allow access on port 22
  ingress {
    description      = "ssh access"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["${data.external.my_ip.result}"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = -1
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags   = {
    Name = "Techscrum SonarQube server security group"
  }
}

# create security group for the ec2 instance
resource "aws_security_group" "ansible_security_group" {
  name        = "jenkins security group"
  description = "allow access on ports 8080 and 22"
  vpc_id      = aws_default_vpc.default_vpc.id

  # allow access on port 22
  ingress {
    description      = "ssh access"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["${data.external.my_ip.result}"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = -1
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags   = {
    Name = "Techscrum SonarQube server security group"
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

# launch the ec2 instances
resource "aws_instance" "jenkins_frontend" {
  ami                    = "ami-0df609f69029c9bdb"
  instance_type          = "t2.micro"
  subnet_id              = aws_default_subnet.default_az1.id
  vpc_security_group_ids = [aws_security_group.jenkins_security_group.id]
  key_name               = "Jenkins_key"

  tags = {
    Name = "Techscrum Jenkins Frontend"
  }
}

resource "aws_instance" "jenkins_backend" {
  ami                    = "ami-0df609f69029c9bdb"
  instance_type          = "t2.micro"
  subnet_id              = aws_default_subnet.default_az1.id
  vpc_security_group_ids = [aws_security_group.jenkins_security_group.id]
  key_name               = "Jenkins_key"

  tags = {
    Name = "Techscrum Jenkins Backend"
  }
}

resource "aws_instance" "sonarqueb" {
  ami                    = "ami-0df609f69029c9bdb"
  instance_type          = "t2.micro"
  subnet_id              = aws_default_subnet.default_az1.id
  vpc_security_group_ids = [aws_security_group.sonarqube_security_group.id]
  key_name               = "Jenkins_key"

  tags = {
    Name = "Techscrum Sonarqube"
  }
}

resource "aws_instance" "ansible" {
  ami                    = "ami-0df609f69029c9bdb"
  instance_type          = "t2.micro"
  subnet_id              = aws_default_subnet.default_az1.id
  vpc_security_group_ids = [aws_security_group.ansible_security_group.id]
  key_name               = "Jenkins_key"

  tags = {
    Name = "Techscrum Ansible"
  }
}
