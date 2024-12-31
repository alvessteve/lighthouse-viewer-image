#!/bin/bash

# Set strict error handling
set -euo pipefail

# Colors for output
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Default test variables (can be overridden)
DEFAULT_HEALTH_CHECK_TIMEOUT=30
DEFAULT_PORT=7333

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
    cleanup "$CONTAINER_NAME" "$IMAGE_NAME"
    exit 1
}

cleanup() {
    local container_name="$1"
    local image_name="$2"
    echo "Cleaning up test container..."
    docker stop "$container_name" 2>/dev/null || true
    docker rm "$container_name" 2>/dev/null || true
    docker rmi "$image_name" 2>/dev/null || true
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

run_container_tests() {
    local container_name="$1"
    local image_name="$2"
    local port="${3:-$DEFAULT_PORT}"
    local health_check_timeout="${4:-$DEFAULT_HEALTH_CHECK_TIMEOUT}"
    local build_context="${5:-.}"

    # Export variables for use in error handling
    export CONTAINER_NAME="$container_name"
    export IMAGE_NAME="$image_name"

    # Cleanup before starting
    cleanup "$container_name" "$image_name"

    echo "Running integration tests..."

    # Test 1: Build the image
    echo "Test 1: Building Docker image..."
    if docker build -t "$image_name" "$build_context"; then
        log_success "Docker image built successfully"
    else
        handle_test_failure "Failed to build Docker image"
    fi

    # Test 2: Check if image exists
    echo "Test 2: Checking if image exists..."
    if docker image inspect "$image_name" >/dev/null 2>&1; then
        log_success "Image exists"
    else
        handle_test_failure "Image does not exist"
    fi

    # Test 3: Run container
    echo "Test 3: Running container..."
    if docker run -d --name "$container_name" -p "$port:$port" "$image_name"; then
        log_success "Container started successfully"
    else
        handle_test_failure "Failed to start container"
    fi

    # Test 4: Check if container is running
    echo "Test 4: Checking if container is running..."
    if docker ps | grep "$container_name" >/dev/null; then
        log_success "Container is running"
    else
        handle_test_failure "Container is not running"
    fi

    # Test 5: Wait for health check
    echo "Test 5: Checking container health..."
    if wait_for_health "$health_check_timeout" "$container_name"; then
        log_success "Container is healthy"
    else
        handle_test_failure "Container health check failed"
    fi

    # Test 6: Check if port is accessible
    echo "Test 6: Testing HTTP endpoint..."
    if curl -f "http://localhost:$port/" >/dev/null 2>&1; then
        log_success "HTTP endpoint is accessible"
    else
        handle_test_failure "HTTP endpoint is not accessible"
    fi

    # All tests passed
    echo -e "\n${GREEN}All tests passed successfully!${NC}"
    
    # Cleanup
    cleanup "$container_name" "$image_name"
}
