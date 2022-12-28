#!/bin/bash
#install docker
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"

sudo apt-get update

apt-cache policy docker-ce

sudo apt-get install -y docker-ce

sudo usermod -aG docker ubuntu

sudo systemctl status docker

# Install docker-compose
#sudo curl -L "https://github.com/docker/compose/releases/download/1.29.1/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
# Change file mode
#sudo chmod +x /usr/local/bin/docker-compose


#Install trivy 
wget https://github.com/aquasecurity/trivy/releases/download/v0.18.3/trivy_0.18.3_Linux-64bit.deb

sudo dpkg -i trivy_0.18.3_Linux-64bit.deb


#Install Jenkins
sudo apt update

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