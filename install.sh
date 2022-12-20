#!/bin/bash
sudo yum update –y
#Search for Docker package:
sudo yum search docker
#Get version information:
sudo yum info docker
#Install docker
sudo yum install docker -y
# If need docker-compose too:
# 1. Get pip3 
sudo yum install python3-pip
 # 2. Then run any one of the following
sudo pip3 install docker-compose # with root access
#Enable docker service at AMI boot time:
sudo systemctl enable docker.service
#Start the Docker service:
sudo systemctl start docker.service

#Install yum-config-manager to manage your repositories.
#sudo yum install -y yum-utils
#Use yum-config-manager to add the official HashiCorp Linux repository.
#sudo yum-config-manager --add-repo https://rpm.releases.hashicorp.com/AmazonLinux/hashicorp.repo
#Install Terraform from the new repository.
#sudo yum -y install terraform

#Install git in your EC2 instance
sudo yum install git -y
#Check git version
git version
#initialize git local repository
git init

#Install Jenkins
sudo wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo
sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io.key
sudo yum upgrade -y
sudo amazon-linux-extras install java-openjdk11 -y
sudo yum install jenkins -y
sudo systemctl enable jenkins
sudo systemctl start jenkins
sudo cat /var/lib/jenkins/secrets/initialAdminPassword
