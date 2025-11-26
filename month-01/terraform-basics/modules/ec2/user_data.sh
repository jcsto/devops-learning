#!/bin/bash
set -e

# Update system
yum update -y

# Install essential tools
yum install -y \
  git \
  curl \
  wget \
  htop \
  net-tools \
  vim \
  aws-cli

# Install Docker
amazon-linux-extras install -y docker

# Start Docker
systemctl start docker
systemctl enable docker

# Add ec2-user to docker group
usermod -a -G docker ec2-user

# Install Docker Compose
curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

# Install CloudWatch agent
wget https://s3.amazonaws.com/amazoncloudwatch-agent/amazon_linux/amd64/latest/amazon-cloudwatch-agent.rpm
rpm -U ./amazon-cloudwatch-agent.rpm

# Create application directory
mkdir -p /opt/app
cd /opt/app

# Simple health check app
cat > /opt/app/health-check.sh << 'HEALTH_EOF'
#!/bin/bash
while true; do
  echo "$(date): Service is running" >> /var/log/health-check.log
  sleep 60
done
HEALTH_EOF

chmod +x /opt/app/health-check.sh

# Create systemd service for health check
cat > /etc/systemd/system/health-check.service << 'SERVICE_EOF'
[Unit]
Description=Health Check Service
After=network.target

[Service]
Type=simple
ExecStart=/opt/app/health-check.sh
Restart=always
RestartSec=10
StandardOutput=journal
StandardError=journal

[Install]
WantedBy=multi-user.target
SERVICE_EOF

systemctl daemon-reload
systemctl start health-check
systemctl enable health-check

# Log completion
echo "EC2 initialization completed at $(date)" > /var/log/initialization.log

