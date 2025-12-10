# Multi-Tier Application Deployment Guide

This is a multi-tier application consisting of a React frontend and Node.js API backend, containerized with Docker Compose.

## Prerequisites

1. **Docker** - Install Docker Engine
2. **Docker Compose** - Install Docker Compose
3. **Git** - Install Git for cloning the repository

### Installation Commands

#### Ubuntu/Debian:

```bash
# Update package index
sudo apt-get update

# Install Docker
sudo apt-get install -y docker.io docker-compose git

# Start Docker service
sudo systemctl start docker
sudo systemctl enable docker

# Add user to docker group (optional, to run without sudo)
sudo usermod -aG docker $USER
```

#### Amazon Linux 2:

```bash
# Install Docker
sudo yum install -y docker git
sudo service docker start
sudo usermod -a -G docker ec2-user

# Install Docker Compose
sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
```

## Deployment Steps

### 1. Clone the Repository

```bash
git clone <repository-url>
cd multi-tier-app
```

### 2. Configure Public IP

Create a `.env` file from the example:

```bash
cp .env.example .env
```

Edit `.env` and replace `your.public.ip.address` with your cloud VM's public IP:

```bash
nano .env
# or
vi .env
```

Example:

```
PUBLIC_IP=54.123.45.67
```

**Important:** You can find your public IP using:

```bash
curl http://checkip.amazonaws.com
# or
curl ifconfig.me
```

### 3. Build and Start Services

```bash
docker-compose up -d --build
```

This will:

- Build the frontend React application
- Build the API backend service
- Start both services in detached mode

### 4. Configure Security Group (Cloud Provider)

Open the following ports in your cloud VM's security group:

- **Port 8080** (TCP) - Frontend access (required)
- **Port 5000** (TCP) - API access (optional, only if direct API access needed)

**Note:** Frontend communicates with backend internally via Docker network, so no security group changes needed for internal communication. Port 5000 is only needed if you want to access the API directly from outside.

#### AWS EC2 Security Group:

1. Go to EC2 Console → Security Groups
2. Select your instance's security group
3. Edit Inbound Rules
4. Add rules:
   - Type: Custom TCP, Port: 8080, Source: 0.0.0.0/0
   - Type: Custom TCP, Port: 5000, Source: 0.0.0.0/0

### 5. Verify Deployment

Access the application:

- **Frontend:** `http://<your-public-ip>:8080`
- **API Health Check:** `http://<your-public-ip>:5000/api/health`
- **API Info:** `http://<your-public-ip>:5000/api/info`

### 6. Check Service Status

```bash
# View running containers
docker-compose ps

# View logs
docker-compose logs -f

# View logs for specific service
docker-compose logs -f frontend
docker-compose logs -f api
```

## Troubleshooting

### Services not starting:

```bash
# Check logs
docker-compose logs

# Rebuild containers
docker-compose down
docker-compose up -d --build
```

### Cannot access from browser:

- Verify security group rules are applied
- Check if ports are open: `netstat -tuln | grep -E '8080|5000'`
- Verify firewall settings on the VM

### Update Public IP:

1. Edit `.env` file with new IP
2. Restart services: `docker-compose restart`

## Stopping the Application

```bash
# Stop services
docker-compose down

# Stop and remove volumes
docker-compose down -v
```

## Architecture

- **Frontend:** React app served via Nginx (Port 8080)
- **Backend API:** Node.js/Express (Port 5000)
- **Network:** Docker bridge network for inter-service communication
