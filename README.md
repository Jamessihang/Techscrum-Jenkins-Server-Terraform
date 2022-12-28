# Techscrum-Server
If you need one server for testing, you can Use terraform code in terraform folder.
If you need Terraform and Ansible to generate multiple servers, please use the terraform code in root directory.

# How to use docker compose to generate a SonarQube Server
# EC2 instance with Ubuntu ami at least t2.small
# Port 9000 is open in security group

# Run these command in your terminal
sysctl -w vm.max_map_count=524288
sysctl -w fs.file-max=131072
ulimit -n 131072
ulimit -u 8192

# To make changes are getting into effect
sudo sysctl -p

# Add current user to docker group
sudo usermod -aG docker $USER

# Create docker-compose.yml on EC2 instance
sudo vi docker-compose.yml

# Copy all the content in docker-compose.yml 

# Save the file :wq!

# Execute the compose file with command
sudo docker-compose up -d

# Make sure is up and running
sudo docker-compose logs --follow

# Terminate the docker compose
sudo docker-compose down
