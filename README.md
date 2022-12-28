# Techscrum-Server
If you need one server for testing, you can Use terraform code in terraform folder.
If you need Terraform and Ansible to generate multiple servers, please use the terraform code in root directory.

# How to use docker compose to generate a SonarQube Server
# EC2 instance with Ubuntu ami at least t2.small
# Port 9000 is open in security group
# install docker
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"

sudo apt-get update

apt-cache policy docker-ce

sudo apt-get install -y docker-ce

sudo usermod -a -G docker ubuntu

sudo systemctl status docker

# install docker compose
sudo curl -L "https://github.com/docker/compose/releases/download/1.24.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose

# Change file mode
sudo chmod +x /usr/local/bin/docker-compose

# Check docker-compose version
docker-compose --version

# Run these command in your terminal
sudo sysctl -w vm.max_map_count=262144

# Create docker-compose.yml on EC2 instance
sudo vi docker-compose.yml

# Copy all the content in docker-compose.yml 

# Save the file :wq

# Execute the compose file with command
sudo docker-compose up 

# Make sure is up and running
sudo docker-compose logs --follow

# Terminate the docker compose
sudo docker-compose down
