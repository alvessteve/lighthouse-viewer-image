#!/bin/bash

# Set strict error handling
set -euo pipefail

# Colors for output
GREEN='\033[0;32m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo -e "${BLUE}Script directory:${NC} ${SCRIPT_DIR}"

# Test directories
CADDY_TEST_DIR="$SCRIPT_DIR/caddy"
NGINX_TEST_DIR="$SCRIPT_DIR/nginx"

# Function to run tests for a specific service
run_service_tests() {
    local service_dir=$1
    local service_name=$2
    
    echo -e "\n${BLUE}Running tests for $service_name...${NC}"
    
    if [ -f "$service_dir/integration-test.sh" ]; then
        cd "$service_dir"
        chmod +x "$service_dir/integration-test.sh"
        if "$service_dir/integration-test.sh"; then
            echo -e "${GREEN}✓ $service_name tests passed${NC}"
            return 0
        else
            echo -e "${RED}✗ $service_name tests failed${NC}"
            return 1
        fi
        cd ..
    else
        echo -e "${RED}✗ No tests found for $service_name${NC}"
        return 1
    fi
}

# Main execution
echo -e "${BLUE}Starting integration tests...${NC}"

# Track overall success
OVERALL_SUCCESS=true

# Run Caddy tests
if ! run_service_tests "$CADDY_TEST_DIR" "Caddy"; then
    OVERALL_SUCCESS=false
fi

# Run Nginx tests (if they exist)
if [ -d "$NGINX_TEST_DIR" ]; then
    if ! run_service_tests "$NGINX_TEST_DIR" "Nginx"; then
        OVERALL_SUCCESS=false
    fi
fi

# Final result
if [ "$OVERALL_SUCCESS" = true ]; then
    echo -e "\n${GREEN}All tests completed successfully!${NC}"
    exit 0
else
    echo -e "\n${RED}Some tests failed. Please check the output above for details.${NC}"
    exit 1
fi
