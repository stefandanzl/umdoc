#!/bin/bash

# Create the necessary directories
mkdir -p output

echo "Building Linux-only version..."
docker build -f Dockerfile.linux -t umdoc-builder-linux .
docker run --rm -v "$(pwd)/output:/output" umdoc-builder-linux bash -c "cp /build/umdoc/build-linux/umdoc /output/umdoc-linux && echo 'Linux executable copied to output directory.'"

echo "Build process completed. Check the 'output' directory for the Linux executable."
