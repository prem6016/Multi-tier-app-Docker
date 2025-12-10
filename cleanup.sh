#!/bin/bash

# Multi-Tier Application Cleanup Script

echo "=== Multi-Tier Application Cleanup ==="

# Function to check if containers are running
check_containers() {
    if docker-compose ps | grep -q "Up"; then
        return 0
    else
        return 1
    fi
}

# Stop and remove containers
echo "Stopping and removing containers..."
docker-compose down

# Remove images (optional - uncomment if needed)
if [ "$1" == "--all" ] || [ "$1" == "-a" ]; then
    echo "Removing images..."
    docker-compose down --rmi all
    
    echo "Removing volumes..."
    docker-compose down -v
    
    echo "Pruning unused Docker resources..."
    docker system prune -f
fi

# Remove networks (if not removed by docker-compose down)
echo "Cleaning up networks..."
docker network prune -f

echo ""
echo "=== Cleanup Complete ==="
echo "Containers stopped and removed."

if [ "$1" == "--all" ] || [ "$1" == "-a" ]; then
    echo "Images, volumes, and unused resources removed."
    echo ""
    echo "To remove .env file, run: rm .env"
else
    echo ""
    echo "To remove images and volumes, run: ./cleanup.sh --all"
fi

