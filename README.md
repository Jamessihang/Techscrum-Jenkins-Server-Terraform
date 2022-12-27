# Techscrum-Server
Use terraform code 

# Update the installed packages and package cache on your instance.

sudo yum update -y

# Install the most recent Docker Engine package.

sudo amazon-linux-extras install docker

# Start the Docker service.

sudo service docker start

# (Optional) To ensure that the Docker daemon starts after each system reboot, run the following command:

sudo systemctl enable docker

# Add the ec2-user to the docker group so you can execute Docker commands without using sudo.

sudo usermod -a -G docker ec2-user

# Verify that you can run Docker commands without sudo.

docker info

# Install docker-compose

sudo curl -L "https://github.com/docker/compose/releases/download/1.29.1/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose

sudo chmod +x /usr/local/bin/docker-compose

docker-compose version

# How to use docker compose to generate a SonarQube Server
# EC2 at least t2.small
# Port 9000 is open in security group

sudo vi etc/sysctl.conf

# Add following to the bottom of that file
vm.max_map_count=262144
fs.file-max=65536

# To make changes are getting into effect
sudo sysctl -p

# Add current user to docker group
sudo usermod -aG docker $USER

# Create docker-compose.yml
sudo vi docker-compose.yml

# Copy all the content in docker-compose.yml

# Save the file :wq!

# Execute the compose file with command
sudo docker-compose up -d

# Make sure is up and running
sudo docker-compose logs -follow

# Terminate the docker compose
sudo docker-compose down
