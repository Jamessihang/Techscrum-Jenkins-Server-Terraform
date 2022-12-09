#!/bin/bash
sudo yum update –y
#Install git in your EC2 instance
sudo yum install git -y
#Check git version
git version
#create a directory named employee
mkdir mygit
#get inside mygit directory
cd mygit/
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