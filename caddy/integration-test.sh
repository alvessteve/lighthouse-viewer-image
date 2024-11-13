#!/bin/bash

set -euxo pipefail

eval "$(ssh-agent -s)"
if [[ "$OSTYPE" == "darwin"* ]]; then
    ssh-add --apple-use-keychain
else
    ssh-add
fi

docker image build --ssh default -t lighthouse-test .
docker run -p 7333:7333 --name lighthouse-test-container --detach lighthouse-test

# sleep to let the container start
sleep 1

set +e
response=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:7333)

if [[ $response -eq 200 ]]; then
    echo "Request successful"
    EXIT_CODE=0
else
    echo "Request failed with status code: $response"
    EXIT_CODE=1
fi

set -e

docker stop lighthouse-test-container
docker rm lighthouse-test-container

exit $EXIT_CODE