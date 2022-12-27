# Techscrum-Server
Use terraform code 

# How to use docker compose to generate a SonarQube Server
# EC2 at least t2.small
# Port 9000 is open in security group

sudo vi /etc/sysctl.conf

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
sudo docker-compose logs --follow

# Terminate the docker compose
sudo docker-compose down
