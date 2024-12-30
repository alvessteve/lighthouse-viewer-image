#!/bin/bash

# Set strict error handling
set -euo pipefail

# Colors for output
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Test variables
CONTAINER_NAME="lighthouse-viewer-nginx-test"
IMAGE_NAME="lighthouse-viewer-nginx:test"
EXPECTED_PORT=7333
HEALTH_CHECK_TIMEOUT=30

# Helper functions
log_success() {
    echo -e "${GREEN}✓ $1${NC}"
}

log_error() {
    echo -e "${RED}✗ $1${NC}"
    exit 1
}

cleanup() {
    echo "Cleaning up test container..."
    docker stop "$CONTAINER_NAME" 2>/dev/null || true
    docker rm "$CONTAINER_NAME" 2>/dev/null || true
    docker rmi "$IMAGE_NAME" 2>/dev/null || true
}

wait_for_port() {
    local timeout=$1
    local counter=0
    
    echo "Waiting for service to be available..."
    while [ $counter -lt $timeout ]; do
        if curl -s -f "http://localhost:$EXPECTED_PORT" >/dev/null; then
            return 0
        fi
        sleep 1
        counter=$((counter + 1))
    done
    return 1
}

# Cleanup before starting
cleanup

echo "Running integration tests..."

# Test 1: Build the image
echo "Test 1: Building Docker image..."
if docker build -t "$IMAGE_NAME" .; then
    log_success "Docker image built successfully"
else
    log_error "Failed to build Docker image"
fi

# Test 2: Check if image exists
echo "Test 2: Checking if image exists..."
if docker image inspect "$IMAGE_NAME" >/dev/null 2>&1; then
    log_success "Image exists"
else
    log_error "Image does not exist"
fi

# Test 3: Run container
echo "Test 3: Running container..."
if docker run -d --name "$CONTAINER_NAME" -p "$EXPECTED_PORT:$EXPECTED_PORT" "$IMAGE_NAME"; then
    log_success "Container started successfully"
else
    log_error "Failed to start container"
fi

# Test 4: Check if container is running
echo "Test 4: Checking if container is running..."
if docker ps | grep "$CONTAINER_NAME" >/dev/null; then
    log_success "Container is running"
else
    log_error "Container is not running"
fi

# Test 5: Wait for service availability
echo "Test 5: Checking service availability..."
if wait_for_port $HEALTH_CHECK_TIMEOUT; then
    log_success "Service is available"
else
    log_error "Service availability check failed"
fi

# Test 6: Check if running as non-root
echo "Test 6: Checking if container runs as non-root..."
if [ "$(docker exec $CONTAINER_NAME id -u)" != "0" ]; then
    log_success "Container is running as non-root user"
else
    log_error "Container is running as root user"
fi

# Test 7: Check Nginx version
echo "Test 7: Checking Nginx version..."
if docker exec $CONTAINER_NAME nginx -v 2>&1 | grep -q "nginx version"; then
    log_success "Nginx version verified"
else
    log_error "Nginx version check failed"
fi

# Test 8: Check Nginx configuration
echo "Test 8: Testing Nginx configuration..."
if docker exec $CONTAINER_NAME nginx -t >/dev/null 2>&1; then
    log_success "Nginx configuration is valid"
else
    log_error "Nginx configuration is invalid"
fi

# Cleanup after tests
cleanup

echo -e "${GREEN}All tests passed successfully!${NC}"
