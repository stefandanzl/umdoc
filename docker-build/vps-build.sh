#!/bin/bash

# Make sure we're in the right directory
cd "$(dirname "$0")"

echo "=========================================================="
echo "Building umdoc Linux executable..."
echo "=========================================================="

# Create output directory
mkdir -p output

# Build using the Linux-only Dockerfile
echo "Building Docker image for Linux build..."
docker build -f Dockerfile.linux -t umdoc-builder-linux .

# Run the container to extract the executable
echo "Extracting executable from container..."
docker run --rm -v "$(pwd)/output:/output" umdoc-builder-linux bash -c "find /build -name umdoc -type f -not -path '*/\.*' | xargs -I{} cp {} /output/umdoc-linux && chmod +x /output/umdoc-linux && echo 'Linux executable copied to output directory.'"

echo "=========================================================="
echo "Build process completed!"
echo "The Linux executable should be in: $(pwd)/output/umdoc-linux"
echo "=========================================================="

# Check if executable exists
if [ -f "$(pwd)/output/umdoc-linux" ]; then
  echo "Success! Executable found."
  file "$(pwd)/output/umdoc-linux"
  ls -la "$(pwd)/output/umdoc-linux"
else
  echo "Error: Executable not found in output directory."
  echo "Container output directory contents:"
  docker run --rm -v "$(pwd)/output:/output" umdoc-builder-linux ls -la /build/umdoc/build-linux/
fi
