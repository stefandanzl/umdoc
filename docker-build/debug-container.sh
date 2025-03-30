#!/bin/bash

# This script finds where the umdoc executable is in the build
echo "Looking for the umdoc executable in the container..."
docker run --rm umdoc-builder-linux bash -c "find /build -name umdoc -type f | grep -v '/\.' && echo '---' && ls -la /build/umdoc/build-linux/"
