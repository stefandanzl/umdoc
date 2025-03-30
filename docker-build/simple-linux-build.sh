#!/bin/bash

# Super simple build script that focuses only on building the Linux version
# without requiring docker-compose or MinGW files

# Create output directory
mkdir -p output

echo "Building Linux version of umdoc..."
echo "=========================================="

# Build using the Linux-only Dockerfile
docker build -f Dockerfile.linux -t umdoc-builder-linux .

# Run the container to extract the executable
echo "Extracting executable from container..."
docker run --rm -v "$(pwd)/output:/output" umdoc-builder-linux bash -c "find /build -name umdoc -type f | grep -v '/\.' | xargs ls -la"
docker run --rm -v "$(pwd)/output:/output" umdoc-builder-linux bash -c "find /build -name umdoc -type f | grep -v '/\.' | xargs -I{} cp {} /output/umdoc-linux && chmod +x /output/umdoc-linux && echo 'Linux executable copied to output directory.'"

# Verify the executable exists
if [ -f "output/umdoc-linux" ]; then
    echo "=========================================="
    echo "Build successful! Executable is at: output/umdoc-linux"
    ls -la output/umdoc-linux
else
    echo "=========================================="
    echo "Error: Build failed, executable not found"
    echo "Showing build directory content:"
    docker run --rm umdoc-builder-linux bash -c "ls -la /build/umdoc/build-linux/"
fi
