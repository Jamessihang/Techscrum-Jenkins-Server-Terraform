#!/bin/bash
sudo apt-get update
#Install docker
#sudo apt install apt-transport-https ca-certificates curl software-properties-common -y
#Enable docker service at AMI boot time:
#curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
#Start the Docker service:
#sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu focal stable"

#apt-cache policy docker-ce

#sudo apt install docker-ce -y


#Install git in your EC2 instance
#sudo apt install git -y
#Check git version
#git --version
#initialize git local repository
#git init


#Install trivy 
wget https://github.com/aquasecurity/trivy/releases/download/v0.18.3/trivy_0.18.3_Linux-64bit.deb
sudo dpkg -i trivy_0.18.3_Linux-64bit.deb


#Install Jenkins
sudo apt install openjdk-11-jre -y
curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io.key | sudo tee \
  /usr/share/keyrings/jenkins-keyring.asc > /dev/null
echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] \
  https://pkg.jenkins.io/debian-stable binary/ | sudo tee \
  /etc/apt/sources.list.d/jenkins.list > /dev/null
sudo apt-get update
sudo apt-get install jenkins -y
sudo systemctl enable jenkins
sudo systemctl start jenkins
sudo cat /var/lib/jenkins/secrets/initialAdminPassword