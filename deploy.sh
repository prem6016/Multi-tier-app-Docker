#!/bin/bash

# Multi-Tier Application Deployment Script

echo "=== Multi-Tier Application Deployment ==="

# Check if Docker is installed
if ! command -v docker &> /dev/null; then
    echo "Error: Docker is not installed. Please install Docker first."
    exit 1
fi

# Check if Docker Compose is installed
if ! command -v docker-compose &> /dev/null; then
    echo "Error: Docker Compose is not installed. Please install Docker Compose first."
    exit 1
fi

# Get public IP if not set
if [ ! -f .env ]; then
    echo "Creating .env file..."
    PUBLIC_IP=$(curl -s http://checkip.amazonaws.com || curl -s ifconfig.me || echo "your.public.ip.address")
    echo "PUBLIC_IP=${PUBLIC_IP}" > .env
    echo "Public IP detected: ${PUBLIC_IP}"
    echo "Please verify and update .env if needed."
else
    echo ".env file already exists"
fi

# Build and start services
echo "Building and starting services..."
docker-compose up -d --build

# Wait for services to be ready
echo "Waiting for services to start..."
sleep 5

# Check service status
echo ""
echo "=== Service Status ==="
docker-compose ps

echo ""
echo "=== Deployment Complete ==="
echo "Frontend: http://$(grep PUBLIC_IP .env | cut -d '=' -f2):8080"
echo "API: http://$(grep PUBLIC_IP .env | cut -d '=' -f2):5000/api/health"
echo ""
echo "Make sure to configure security group rules for ports 8080 and 5000"

