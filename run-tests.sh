#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/test/utils.sh"

# Colors for output
GREEN='\033[0;32m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Enable strict mode
set -euo pipefail

echo -e "${BLUE}Starting integration tests...${NC}"

OVERALL_SUCCESS=true

run_server_tests() {
    local server_name=$1
    local container_name=$2
    local image_name=$3
    
    cd "$SCRIPT_DIR/$server_name" || exit
    echo -e "\n${BLUE}Running $server_name tests...${NC}"
    if ! run_container_tests "$container_name" "$image_name" "7333" "30" "."; then
        OVERALL_SUCCESS=false
    fi
}

# Run tests for both servers
run_server_tests "caddy" "lighthouse-viewer-test" "lighthouse-viewer:test"
run_server_tests "nginx" "lighthouse-viewer-nginx-test" "lighthouse-viewer-nginx:test"

# Final result
if [ "$OVERALL_SUCCESS" = true ]; then
    echo -e "\n${GREEN}All tests completed successfully!${NC}"
    exit 0
else
    echo -e "\n${RED}Some tests failed. Please check the output above for details.${NC}"
    exit 1
fi
