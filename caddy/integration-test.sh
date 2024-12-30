#!/bin/bash

# Set strict error handling
set -euo pipefail

# Colors for output
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Test variables
CONTAINER_NAME="lighthouse-viewer-test"
IMAGE_NAME="lighthouse-viewer:test"
EXPECTED_PORT=7333
HEALTH_CHECK_TIMEOUT=30

# Helper functions
log_success() {
    echo -e "${GREEN}✓ $1${NC}"
}

log_error() {
    echo -e "${RED}✗ $1${NC}"
}

handle_test_failure() {
    local error_message="$1"
    log_error "$error_message"
    cleanup
    exit 1
}

cleanup() {
    echo "Cleaning up test container..."
    docker stop "$CONTAINER_NAME" 2>/dev/null || true
    docker rm "$CONTAINER_NAME" 2>/dev/null || true
    docker rmi "$IMAGE_NAME" 2>/dev/null || true
}

wait_for_health() {
    local timeout=$1
    local container=$2
    local counter=0
    
    echo "Waiting for container to be healthy..."
    while [ $counter -lt $timeout ]; do
        if [ "$(docker inspect --format='{{.State.Health.Status}}' $container)" == "healthy" ]; then
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
    handle_test_failure "Failed to build Docker image"
fi

# Test 2: Check if image exists
echo "Test 2: Checking if image exists..."
if docker image inspect "$IMAGE_NAME" >/dev/null 2>&1; then
    log_success "Image exists"
else
    handle_test_failure "Image does not exist"
fi

# Test 3: Run container
echo "Test 3: Running container..."
if docker run -d --name "$CONTAINER_NAME" -p "$EXPECTED_PORT:$EXPECTED_PORT" "$IMAGE_NAME"; then
    log_success "Container started successfully"
else
    handle_test_failure "Failed to start container"
fi

# Test 4: Check if container is running
echo "Test 4: Checking if container is running..."
if docker ps | grep "$CONTAINER_NAME" >/dev/null; then
    log_success "Container is running"
else
    handle_test_failure "Container is not running"
fi

# Test 5: Wait for health check
echo "Test 5: Checking container health..."
if wait_for_health $HEALTH_CHECK_TIMEOUT "$CONTAINER_NAME"; then
    log_success "Container is healthy"
else
    handle_test_failure "Container health check failed"
fi

# Test 6: Check if port is accessible
echo "Test 6: Testing port accessibility..."
if curl -s -f "http://localhost:$EXPECTED_PORT" >/dev/null; then
    log_success "Port $EXPECTED_PORT is accessible"
else
    handle_test_failure "Port $EXPECTED_PORT is not accessible"
fi

# Test 7: Check if running as non-root
echo "Test 7: Checking if container runs as non-root..."
if [ "$(docker exec $CONTAINER_NAME id -u)" != "0" ]; then
    log_success "Container is running as non-root user"
else
    handle_test_failure "Container is running as root user"
fi

# Test 8: Check Caddy version
echo "Test 8: Checking Caddy version..."
if docker exec $CONTAINER_NAME caddy version | grep -q "v2.8.4"; then
    log_success "Correct Caddy version installed"
else
    handle_test_failure "Incorrect Caddy version"
fi

# Cleanup after tests
cleanup

echo -e "${GREEN}All tests passed successfully!${NC}"